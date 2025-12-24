class_name Door
extends Sprite2D

## Transition point between Rooms that must be interacted with by the Player.
## Handles transition UI and transfer to other rooms.

@onready var interaction_zone: InteractionZone = $InteractionZone

@export_file("*.tscn") var room_path: String
@export var tag: StringName

@export var display_sprite: bool = true

const TRANS_SCENE := preload("res://Utility/Transition/Transition.tscn")

func _ready() -> void:
	interaction_zone.interacted.connect(_on_open)

	if not display_sprite:
		modulate.a = 0.0

func _on_open(_body: Node2D) -> void:
	GameManager.interaction_queue.push_front({
		"method": func():
			_do_door_transition(),
		"priority": 5
	})

func _do_door_transition() -> void:
	if not room_path:
		push_warning("Trying to start a transition with an unset room.")
		return
	
	# Prevent Player from moving until transition is over.
	GameManager.state = GameManager.GameState.STANDBY
	
	# Update spawn tag
	GameManager.spawn_tag = tag
	
	var trans = TRANS_SCENE.instantiate() as Transition
	get_tree().root.add_child(trans)
	
	await trans.screen_filled
	
	var room_scene = load(room_path) as PackedScene
	var inst = room_scene.instantiate()
	
	GameManager.load_room(inst)
