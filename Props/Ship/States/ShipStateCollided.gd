class_name ShipStateCollided
extends ShipState

const STUN_DURATION = 0.5  # Seconds of lost control
const BOUNCE_FORCE = 400.0

var stun_timer = 0.0
var bounce_direction = Vector2.ZERO

func enter() -> void:
	stun_timer = STUN_DURATION
	
	# Apply bounce force in opposite direction of collision
	if bounce_direction != Vector2.ZERO:
		ship.linear_velocity = bounce_direction * BOUNCE_FORCE
	
	if ship.has_method("show_collision_effect"):
		ship.show_collision_effect()

func exit() -> void:
	stun_timer = 0.0
	bounce_direction = Vector2.ZERO

func process(_delta: float) -> void:
	# No control during stun - ship just tumbles
	pass

func physics_process(delta: float) -> void:
	stun_timer -= delta
	
	if stun_timer <= 0:
		# Check if grounded to transition to correct state
		if ship._is_ship_grounded() and ship.linear_velocity.length() < 100.0:
			ship.change_state("parked")
		else:
			ship.change_state("flying")

# Called from ShipController when collision detected
func set_bounce_direction(direction: Vector2) -> void:
	bounce_direction = direction.normalized()
