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
@onready var indicator: InteractionIndicator = $InteractionIndicator

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Doesn't collide, but should only be looking for the Player.
	collision_layer = 0
	collision_mask = 8

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event.is_action_pressed("interact") and _bodies_inside.size() > 0:
		interact(_bodies_inside[0])

func _on_body_entered(body: Node2D) -> void:
	if not enabled:
		return
	
	if body not in _bodies_inside:
		_bodies_inside.append(body)
		entered.emit(body)
	
	if indicator:
		indicator.reveal()

func _on_body_exited(body: Node2D) -> void:
	if body in _bodies_inside:
		_bodies_inside.erase(body)
		exited.emit(body)
	
	if _bodies_inside.size() == 0 and indicator:
		indicator.disappear()

func interact(body: Node2D) -> void:
	if enabled:
		# Remove body from list so that interactions can't be triggered again.
		if body in _bodies_inside:
			_bodies_inside.erase(body)
			
		interacted.emit(body)
	
	# Hide indicator
	if indicator:
		indicator.disappear()
