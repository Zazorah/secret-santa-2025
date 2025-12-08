class_name ShipStateParked
extends ShipState

const TAKEOFF_HOLD_TIME = 1.0  # Seconds to hold jump for takeoff
var takeoff_timer = 0.0

func enter() -> void:
	takeoff_timer = 0.0
	ship.linear_velocity = Vector2.ZERO
	ship.angular_velocity = 0.0
	
	ship.visualizer.flying_particle_emitter.emitting = false
	ship.visualizer.reset_rotation()

func exit() -> void:
	takeoff_timer = 0.0

func process(delta: float) -> void:
	# Check if player is holding jump button
	if Input.is_action_pressed("jump"):
		takeoff_timer += delta
		
		# Call visualizer for takeoff animation (you'll implement this)
		var progress = takeoff_timer / TAKEOFF_HOLD_TIME
		if ship.has_method("update_takeoff_visual"):
			ship.update_takeoff_visual(progress)
		
		# Zoom camera in during take-off
		if GameManager.camera:
			var zoom_level = GameManager.camera.standard_zoom_level + (progress * 0.25)
			GameManager.camera.zoom_target = zoom_level
			GameManager.camera.offset = Vector2(
				0.0,
				-24.0 + (16.0 * progress)
			)
		
		# Transition to flying when timer completes
		if takeoff_timer >= TAKEOFF_HOLD_TIME:
			ship.linear_velocity = Vector2(0.0, -200.0)
			ship.change_state("flying")
	else:
		# Reset timer if button released
		takeoff_timer = 0.0
		
		# Return Camera to Standard Vehicle Zoom
		GameManager.camera.zoom_target = GameManager.camera.standard_zoom_level
		GameManager.camera.offset = Vector2(
			0.0,
			-24.0
		)
		
		if ship.has_method("cancel_takeoff_visual"):
			ship.cancel_takeoff_visual()

func handle_input(event: InputEvent) -> void:
	# Allow exiting only when parked
	if event.is_action_pressed("exit_ship"):
		ship.exit_ship()
