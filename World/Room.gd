class_name Room
extends Node

## Describes a playable room in the game.

const PLAYER_SCENE := preload("res://Entities/Characters/Player/PlayerCharacter.tscn")

var player_spawns: Array[PlayerSpawn]

func _ready() -> void:
	# Set self as current room.
	GameManager.current_room = self
	
	# Gather all information about children.
	for child in get_children():
		if child is PlayerSpawn:
			player_spawns.push_back(child)
	
	# Spawn player at appropriate tag.
	var spawn_pos: Vector2
	for spawn in player_spawns:
		if not spawn_pos and spawn.is_default:
			spawn_pos = spawn.global_position
		
		elif spawn.tag == GameManager.spawn_tag:
			spawn_pos = spawn.global_position
		
		spawn.queue_free()
	
	if not spawn_pos:
		push_warning("Unable to find an appropriate Player spawn..")
	
	var player = PLAYER_SCENE.instantiate() as EntityPlayer
	player.global_position = spawn_pos
	add_child(player)
