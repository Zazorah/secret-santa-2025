class_name TractorBeamController
extends Area2D

# Properties
const PULL_STRENGTH = 150.0

# State
var active: bool
var ship: ShipController
var affecting_bodies: Array[RigidBody2D]

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if get_parent() is ShipController:
		ship = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if active and body not in affecting_bodies:
		if body is RigidBody2D:
			affecting_bodies.push_back(body)

func _on_body_exited(body: Node2D) -> void:
	if body in affecting_bodies:
		var index = affecting_bodies.find(body)
		affecting_bodies.remove_at(index)

func set_active(is_active: bool) -> void:
	if is_active and !active: # Switching to Active
		_on_activate()
	
	elif !is_active and active: # Switching to Inactive
		_on_deactivate()
	
	active = is_active

func _on_activate() -> void:
	pass

func _on_deactivate() -> void:
	# Empty the list of bodies.
	affecting_bodies.clear()

func _physics_process(delta: float) -> void:
	for body in affecting_bodies:
		var direction = (ship.global_position - body.global_position)
		var distance = direction.length()
		direction = direction.normalized()
		
		var strength = PULL_STRENGTH * (1.0 / max(distance, 1.0))
		body.apply_force(direction * strength)
