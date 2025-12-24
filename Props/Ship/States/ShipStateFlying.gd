class_name ShipStateFlying
extends ShipState

const TAKEOFF_BUFFER_CAP = 10 # Amount of frames before we can enter another state.
const UPWARD_THRUST = 800.0
const HORIZONTAL_SPEED = 300.0
const BOUNCE_DAMPING = 0.6  # Velocity multiplier on bounce
const MIN_LANDING_SPEED = 10.0  # Max speed to land safely
const MAX_SPEED = 500.0

var takeoff_buffer: int

var jump_held: bool
var beam_pressed: bool
var beam_released: bool
var horizontal_input: float

func enter() -> void:
	takeoff_buffer = TAKEOFF_BUFFER_CAP
	
	ship.visualizer.flying_particle_emitter.emitting = true
	
	if GameManager.camera:
		GameManager.camera.zoom_target = GameManager.camera.vehicle_zoom_level

func exit() -> void:
	ship.beam.set_active(false)

func process(_delta: float) -> void:
	if not _will_respond_to_inputs():
		jump_held = false
		beam_pressed = false
		beam_released = false
		horizontal_input = 0.0
		return
	
	# Check if thrust and/or beam are held
	jump_held = Input.is_action_pressed("jump")
	beam_pressed = Input.is_action_just_pressed("beam")
	beam_released = Input.is_action_just_released("beam")
	
	# Get horizontal input access
	horizontal_input = Input.get_axis("move_left", "move_right")

func physics_process(_delta: float) -> void:
	# Upward thrust when holding jump
	if jump_held:
		ship.apply_central_force(Vector2.UP * UPWARD_THRUST)
	
	# Horizontal movement
	if horizontal_input != 0:
		ship.apply_central_force(Vector2(horizontal_input * HORIZONTAL_SPEED, 0))
		# Rotate towards horizontal movement
		ship.visualizer.rot_target = 15.0 * horizontal_input
	else:
		ship.visualizer.rot_target = 0.0
	
	if ship.linear_velocity.length() > MAX_SPEED:
		ship.linear_velocity = ship.linear_velocity.normalized() * MAX_SPEED
	
	if takeoff_buffer > 0:
		takeoff_buffer -= 1
		return
	
	# Beam controls
	if beam_pressed:
		ship.beam.set_active(true)
	elif beam_released or (ship.beam.active and not _will_respond_to_inputs()):
		ship.beam.set_active(false)
	
	# Check for ground collision
	if ship._is_ship_grounded():
		var speed = ship.linear_velocity.length()
		
		# If moving slowly, land (transition to parked)
		if speed < MIN_LANDING_SPEED:
			ship.change_state("parked")
		else:
			# Otherwise, bounce off the ground
			_bounce_off_ground()

func _bounce_off_ground() -> void:
	print("Hit the ground too fast.")
	
	# Get ground normal
	var space_state = ship.get_world_2d().direct_space_state
	var ray_query = PhysicsRayQueryParameters2D.create(
		ship.global_position,
		ship.global_position + Vector2.DOWN * 24
	)
	ray_query.collision_mask = 1
	ray_query.exclude = [ship]
	
	var ray_result = space_state.intersect_ray(ray_query)
	
	if ray_result:
		# Reflect velocity off ground normal and dampen it
		var normal = ray_result.normal
		var reflected = ship.linear_velocity.bounce(normal)
		ship.linear_velocity = reflected * BOUNCE_DAMPING
