class_name InteractionZone
extends Area2D

## Defines a space in which the Player can interact with the entity.

# Emitted when the player enters the interaction zone.
signal entered(body: Node2D)

# Emitted when the player exits the interaction zone.
signal exited(body: Node2D)

# Emitted when the player interacts.
signal interacted(body: Node2D)

# Whether or not this zone is currently active.
@export var enabled: bool = true

var _bodies_inside: Array[Node2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	collision_layer = 0
	collision_mask = 1
	
	print("InteractionZone ready on ", get_parent().name)

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event.is_action_pressed("interact") and _bodies_inside.size() > 0:
		interact(_bodies_inside[0])

func _on_body_entered(body: Node2D) -> void:
	if not enabled:
		return
	
	print("Body entered InteractionZone: ", body.name)
	print("Body is Player: ", body is EntityPlayer)
	
	if body not in _bodies_inside:
		_bodies_inside.append(body)
		entered.emit(body)

func _on_body_exited(body: Node2D) -> void:
	if body in _bodies_inside:
		_bodies_inside.erase(body)
		exited.emit(body)

func interact(body: Node2D) -> void:
	if enabled:
		interacted.emit(body)
