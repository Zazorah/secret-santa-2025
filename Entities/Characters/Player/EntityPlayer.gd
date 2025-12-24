class_name EntityPlayer
extends Entity

## Entity class that encapsulates player controls.

# Movement Parameters
@export var move_speed: float = 150.0
@export var jump_velocity: float = -200.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0

# States
enum State {IDLE, WALKING, JUMPING, FALLING, TALKING}
var current_state: State = State.IDLE

# SFX References
const JUMP_SFX := preload("res://Assets/Audio/SFX/Effect_CutInOpen.wav")

func _ready() -> void:
	super._ready()
	
	await get_tree().create_timer(0.1).timeout
	if GameManager.camera:
		GameManager.camera.focus_target = self
	
	GameManager.player = self
	
	# Set Collision Properties
	collision_layer = 8
	collision_mask = 1

func update_velocity(delta: float):
	# Don't respond to any inputs when talking.
	if current_state == State.TALKING:
		return
	
	# Don't respond to any inputs if game is in STANDBY
	if GameManager.state == GameManager.GameState.STANDBY:
		current_state = State.IDLE
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		return
	
	# Pause the game when the input is pressed.
	if GameManager.can_pause and Input.is_action_just_pressed("pause"):
		GameManager.pause_game()
	
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
		
		AudioManager.play_sfx(JUMP_SFX)
		
		if visualizer:
			visualizer.squish(0.5)
	
	if not is_on_floor():
		current_state = State.FALLING if velocity.y > 0 else State.JUMPING
