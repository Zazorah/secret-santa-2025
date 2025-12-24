extends Node

## Auto-load class for managing audio files across the game.

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var available_sfx_players: Array[AudioStreamPlayer] = []

var master_volume: float = 0.25 # Default: 1.0
var music_volume: float = 0.7 # Default: 0.7
var sfx_volume: float = 0.8 # Default: 0.8

var current_music: AudioStream

const MAX_SFX_PLAYERS: int = 16
const DEFAULT_SFX_PITCH_VARIATION: float = 0.1

func _ready() -> void:
	# Create Music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Create SFX player pool
	_create_sfx_player_pool()
	
	# Set initial volumes
	update_volumes()

func _create_sfx_player_pool() -> void:
	for i in range(MAX_SFX_PLAYERS):
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "SFXPlayer_" + str(i)
		add_child(sfx_player)
		sfx_players.append(sfx_player)
		available_sfx_players.append(sfx_player)
		
		sfx_player.finished.connect(_on_sfx_finished.bind(sfx_player))

func _on_sfx_finished(player: AudioStreamPlayer) -> void:
	if player not in available_sfx_players:
		available_sfx_players.append(player)

func play_music(music_stream: AudioStream, volume_multiplier := 1.0) -> void:
	if not music_stream:
		print("AudioManager: No music stream provided")
		return
	
	music_player.volume_db = linear_to_db(master_volume * music_volume * volume_multiplier)
	
	current_music = music_stream
	music_player.stream = music_stream
	
	music_player.play()

func stop_music() -> void:
	music_player.stop()
	current_music = null

func play_sfx(
	sfx_stream: AudioStream,
	pitch_variation: bool = true,
	volume_multiplier: float = 1.0
) -> AudioStreamPlayer:
	var player = _get_available_sfx_player()
	if not player:
		print("AudioManager: No available SFX players")
		return null
	
	# Configure player
	player.stream = sfx_stream
	player.volume_db = linear_to_db(master_volume * sfx_volume * volume_multiplier)

	# Apply pitch variation
	if pitch_variation:
		var pitch_range = DEFAULT_SFX_PITCH_VARIATION
		player.pitch_scale = randf_range(1.0 - pitch_range, 1.0 + pitch_range)
	else:
		player.pitch_scale = 1.0
	
	player.play()
	return player
	
func play_sfx_oneshot(sfx_stream: AudioStream, pitch_variation: bool = true, volume_multiplier: float = 1.0) -> void:
	play_sfx(sfx_stream, pitch_variation, volume_multiplier)

func stop_all_sfx() -> void:
	for player in sfx_players:
		if player.playing:
			player.stop()
	
	# Return all players to available pool
	available_sfx_players.clear()
	available_sfx_players.append_array(sfx_players)

func _get_available_sfx_player() -> AudioStreamPlayer:
	if available_sfx_players.is_empty():
		return null
	
	return available_sfx_players.pop_back()

func set_master_volume(volume: float) -> void:
	master_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func update_volumes():
	if music_player:
		music_player.volume_db = linear_to_db(master_volume * music_volume)

func is_music_playing() -> bool:
	return music_player.playing if music_player else false

## Glue effect properties
const GLUE_PITCH_START := 1.0
const GLUE_PITCH_END := 0.6  # Half speed at max glue
const GLUE_VOLUME_START := 1.0
const GLUE_VOLUME_END := 0.3  # 30% volume at max glue
var glue_level := 0
var max_glue := 9  # Should match your enemy's MAX_GLUE

func apply_glue_to_music() -> void:
	glue_level += 1
	
	var glue_progress = float(glue_level) / float(max_glue)
	
	# Slow down the music
	var target_pitch = lerp(GLUE_PITCH_START, GLUE_PITCH_END, glue_progress)
	music_player.pitch_scale = target_pitch
	
	# Reduce the music volume
	var target_volume = lerp(GLUE_VOLUME_START, GLUE_VOLUME_END, glue_progress)
	music_player.volume_db = linear_to_db(master_volume * music_volume * target_volume)
	
	print("Music glued - Pitch: ", target_pitch, " Volume mult: ", target_volume)
