class_name Room
extends Node

## Describes a playable room in the game.

const PLAYER_SCENE := preload("res://Entities/Characters/Player/PlayerCharacter.tscn")

func _ready() -> void:
	# Set self as current room.
	GameManager.current_room = self
	
	# Spawn player at appropriate tag.
	var spawn_pos = _get_spawn_position(self)
	
	if spawn_pos == Vector2.ZERO:
		push_warning("Unable to find an appropriate Player spawn..")
	
	var player = PLAYER_SCENE.instantiate() as EntityPlayer
	player.global_position = spawn_pos
	add_child(player)

func _get_spawn_position(root: Node) -> Vector2:
	var result: Vector2
	
	for child in root.get_children():
		# Handle PlayerSpawns
		if child is PlayerSpawn:
			if not result and child.is_default:
				result = child.global_position
			elif child.tag and child.tag == GameManager.spawn_tag:
				result = child.global_position
			
			child.queue_free()
		
		# Handle Doors
		elif child is Door:
			if child.tag and child.tag == GameManager.spawn_tag:
				result = child.global_position
		
		# Handle Nodes with Children
		elif child is Node2D and child.get_child_count() > 0:
			var temp = _get_spawn_position(child)
			if temp != Vector2.ZERO:
				result = temp
	
	if not result:
		return Vector2.ZERO

	return result
