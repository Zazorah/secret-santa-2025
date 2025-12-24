class_name Door
extends Sprite2D

## Transition point between Rooms that must be interacted with by the Player.
## Handles transition UI and transfer to other rooms.

@onready var interaction_zone: InteractionZone = $InteractionZone

@export var room: PackedScene
@export var tag: StringName

@export var display_sprite: bool = true

const TRANS_SCENE := preload("res://Utility/Transition/Transition.tscn")

func _ready() -> void:
	interaction_zone.interacted.connect(_on_open)

	if not display_sprite:
		modulate.a = 0.0

func _on_open(_body: Node2D) -> void:
	print("Hello, World!")
	
	GameManager.interaction_queue.push_front({
		"method": func():
			pass,
		"priority": 5
	})

func _do_door_transition() -> void:
	if not room:
		push_warning("Trying to start a transition with an unset room.")
		return
	
	var trans = TRANS_SCENE.instantiate() as Transition
	add_child(trans)
	
	await trans.screen_filled
	GameManager.load_room(room)
	
	pass
