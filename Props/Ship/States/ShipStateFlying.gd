class_name ShipStateFlying
extends ShipState

const TAKEOFF_BUFFER_CAP = 10 # Amount of frames before we can enter another state.
const UPWARD_THRUST = 800.0
const HORIZONTAL_SPEED = 300.0
const BOUNCE_DAMPING = 0.6  # Velocity multiplier on bounce
const MIN_LANDING_SPEED = 100.0  # Max speed to land safely

var takeoff_buffer: int

func enter() -> void:
	takeoff_buffer = TAKEOFF_BUFFER_CAP
	
	if GameManager.camera:
		GameManager.camera.zoom_target = GameManager.camera.vehicle_zoom_level

func physics_process(_delta: float) -> void:
	# Upward thrust when holding jump
	if Input.is_action_pressed("jump"):
		ship.apply_central_force(Vector2.UP * UPWARD_THRUST)
	
	# Horizontal movement
	var horizontal_input = Input.get_axis("move_left", "move_right")
	if horizontal_input != 0:
		ship.apply_central_force(Vector2(horizontal_input * HORIZONTAL_SPEED, 0))
	
	if takeoff_buffer > 0:
		takeoff_buffer -= 1
		return
	
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
