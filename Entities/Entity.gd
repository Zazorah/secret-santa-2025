class_name Entity
extends CharacterBody2D

## High-level class representing something in the game world that responds
## to physics.

# Dependencies - Defined in Scene view.
@onready var visualizer: EntityVisualizer = $EntityVisualizer

# Movement/Physics
@export var gravity: float = 560.0
@export var max_fall_speed: float = 1000.0

func _ready() -> void:
	# Link self with Visualizer
	if visualizer:
		visualizer.entity = self

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	
	# Let subclasses modify velocity
	update_velocity(delta)
	
	# Handle movement
	move_and_slide()
	
	# Update visualizer with current state
	update_visualizer()

func update_velocity(delta: float):
	pass

func update_visualizer():
	if visualizer:
		visualizer.update_animation(velocity, is_on_floor())
