class_name StarController
extends PhysicsProp

const SPRING_STRENGTH = 50.0
const DAMPING = 1.0

@export var star_key: StringName

enum State { FREE, LOCKED }
var current_state = State.FREE

var hover_target: Node2D

func _ready() -> void:
	super._ready()
	
	if star_key:
		var collected = GameManager.star_data.star_is_collected(star_key)
		if collected:
			# Removing from tree because it has already been collected.
			queue_free()
	
	else:
		push_warning(
			"Star was instantiated without a set key.
			Only let this slide in a testing environment."
		)

func _physics_process(_delta: float) -> void:
	if current_state == State.LOCKED:
		if hover_target:
			var direction = (hover_target.global_position - global_position)
			var distance = direction.length()
			direction = direction.normalized()
			
			var spring_force = direction * distance * SPRING_STRENGTH
			var damping_force = -linear_velocity * DAMPING * mass
			
			apply_central_force(spring_force + damping_force)

func _switch_state(new_state: State) -> void:
	if new_state != current_state:
		_on_exit(current_state)
		_on_enter(new_state)
	
	current_state = new_state

func _on_enter(state: State) -> void:
	match state:
		State.LOCKED:
			gravity_scale = 0.0

func _on_exit(state: State) -> void:
	pass

func set_hover_target(target_node: Node2D) -> void:
	hover_target = target_node
	_switch_state(State.LOCKED)
