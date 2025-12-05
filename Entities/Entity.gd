class_name Entity
extends CharacterBody2D

## High-level class representing something in the game world that responds
## to physics.

# Dependencies - Defined in Scene view.
@onready var visualizer: EntityVisualizer = $EntityVisualizer

# Movement/Physics
@export var gravity: float = 460.0
@export var max_fall_speed: float = 1000.0
var was_on_floor = true # Tracking to tell if we just landed on this frame.

func _ready() -> void:
	# Link self with Visualizer
	if visualizer:
		visualizer.entity = self
	
	# Set collision properties
	collision_layer = 2
	collision_mask = 1

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	
	# Let subclasses modify velocity
	update_velocity(delta)
	
	var pre_move_velocity = velocity
	
	# Handle movement
	move_and_slide()
	
	# Push rigidbodies
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			var push_direction = collision.get_normal() * -1
			var push_force = push_direction * pre_move_velocity.length() * 0.5
			
			collider.apply_central_impulse(push_force)
	
	# Update visualizer with current state
	update_visualizer()
	
	was_on_floor = is_on_floor()

func update_velocity(_delta: float):
	pass

func get_entity_context() -> Dictionary:
	return {
		"velocity": velocity,
		"is_on_floor": is_on_floor(),
		"was_on_floor": was_on_floor
	}

func update_visualizer():
	if visualizer:
		visualizer.update_animation(get_entity_context())
