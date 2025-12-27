extends Node

## Autoload singleton for interfacing with Dialog data.

# Loader
var loader: DialogLoader

# Player
var active_player: DialogPlayer

func _init() -> void:
	# Instantiate Dialog Loader
	loader = DialogLoader.new()
	loader.load_dialog()

func has_scene(key: StringName) -> bool:
	return loader.dialog_data.has(key)

func get_scene(key: StringName) -> DialogScene:
	return loader.get_dialog(key)

func play_dialog(key: StringName, speaker_entity: EntityNPC = null) -> DialogPlayer:
	var scene = get_scene(key)
	if not scene:
		push_error("Failed to load scene with the key: ", key)
		return
	
	active_player = DialogPlayer.new(scene)
	
	if speaker_entity:
		active_player.speaker_entity = speaker_entity
		
	get_tree().root.add_child.call_deferred(active_player)
	return active_player
