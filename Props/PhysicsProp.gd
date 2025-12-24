class_name PhysicsProp
extends RigidBody2D

## Class that defines common behaviour for physics objects in the game.
## Props that can be moved around and picked up by the beam.

var cached_linear_velocity: Vector2
var cached_angular_velocity: float

func _ready() -> void:
	# Link GameManager state changes to appropriate method.
	GameManager.state_changed.connect(_on_game_state_change) 

func _on_game_state_change(new_state) -> void:
	match new_state:
		GameManager.GameState.PAUSED:
			freeze = true
			cached_linear_velocity = linear_velocity
			cached_angular_velocity = angular_velocity
			
		_: # The only state Props need to be frozen in is PAUSED.
			if freeze:
				freeze = false
				linear_velocity = cached_linear_velocity
				angular_velocity = cached_angular_velocity
