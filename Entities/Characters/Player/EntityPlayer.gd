class_name EntityPlayer
extends Entity

## Entity class that encapsulates player controls.

# Movement Parameters
@export var move_speed: float = 150.0
@export var jump_velocity: float = -300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0

# States
enum State { IDLE, WALKING, JUMPING, FALLING }
var current_state: State = State.IDLE

func update_velocity(delta: float):
	# Get horizontal input
	var input_dir = Input.get_axis("move_left", "move_right")
	
	# Horizontal movement with acceleration/friction
	if input_dir != 0:
		velocity.x = move_toward(velocity.x, input_dir * move_speed, acceleration * delta)
		current_state = State.WALKING
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		if is_on_floor():
			current_state = State.IDLE
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		current_state = State.JUMPING
	
	if not is_on_floor():
		current_state = State.FALLING if velocity.y > 0 else State.JUMPING
