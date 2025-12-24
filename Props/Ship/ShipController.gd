class_name ShipController
extends PhysicsProp

# State
var piloted := false # Currently being piloted by the player.
var current_state: ShipState
var states := {}

# Node References
@onready var visualizer: ShipVisualizer = $Visualizer
@onready var interaction_zone: InteractionZone = $InteractionZone
@onready var beam: TractorBeamController = $TractorBeam

# Stats
var health = 1

func _ready() -> void:
	super._ready()
	
	# Set collision properties.
	collision_layer = 4
	
	# Setup interactions
	interaction_zone.interacted.connect(func (_node):
		GameManager.interaction_queue.push_front({
			"method": func (): _enter_ship(null),
			"priority": 5
		})
	)
	
	# Setup visualizer
	visualizer.ship = self
	
	# Initialize state machine
	_setup_states()
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	
	# GameManager connect rank up instruction
	GameManager.star_data.rank_increased.connect(func (_new_rank):
		print("Ship health is now: ", _new_rank)
		health = _new_rank
		visualizer.update()
	)
	
	visualizer.update.call_deferred()

func _setup_states() -> void:
	# Create state instances
	var parked_state = ShipStateParked.new()
	var flying_state = ShipStateFlying.new()
	var collided_state = ShipStateCollided.new()
	
	# Set ship reference for each state
	parked_state.ship = self
	flying_state.ship = self
	collided_state.ship = self
	
	# Store states
	states["parked"] = parked_state
	states["flying"] = flying_state
	states["collided"] = collided_state
	
	# Start in parked state
	current_state = states["parked"]
	current_state.enter()

func change_state(state_name: String) -> void:
	if not states.has(state_name):
		push_error("State not found: " + state_name)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.enter()
	
	print("Ship state changed to: ", state_name)

func _process(delta: float) -> void:
	if not piloted:
		# Do auto-heal when not piloted
		pass
	else:
		# Register pause inputs.
		if GameManager.can_pause and Input.is_action_just_pressed("pause"):
			GameManager.pause_game()
		
		if current_state:
			current_state.process(delta)

func _physics_process(delta: float) -> void:
	if piloted and current_state:
		current_state.physics_process(delta)

func _input(event: InputEvent) -> void:
	if piloted and current_state:
		current_state.handle_input(event)

func _on_body_entered(body: Node) -> void:
	# Only trigger collision state when piloted and not already collided
	if piloted and current_state != states["collided"]:
		# Check if it's an obstacle (not ground layer)
		if body.collision_layer != 1:
			# Calculate bounce direction (away from collision point)
			var bounce_dir = (global_position - body.global_position).normalized()
			
			# Transition to collided state
			if states["collided"] is ShipStateCollided:
				states["collided"].set_bounce_direction(bounce_dir)
			
			change_state("collided")

func _enter_ship(_player: Node2D) -> void:
	if piloted or not GameManager.ship_data.can_enter:
		return
	
	# Set Piloted.
	piloted = true
	
	# Destroy Player.
	if GameManager.player:
		GameManager.player.queue_free()
		GameManager.player = null
	
	# Make self the camera focus.
	if GameManager.camera:
		GameManager.camera.focus_target = self
		GameManager.camera.zoom_target = GameManager.camera.vehicle_zoom_level
	
	visualizer.update()

func exit_ship() -> void:
	if not piloted:
		return
	
	# Set not piloted
	piloted = false
	
	# Stop Velocity
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	
	# Spawn player at the position
	_spawn_player(global_position)
	
	# Update camera focus to player
	if GameManager.camera and GameManager.player:
		GameManager.camera.focus_target = GameManager.player
		GameManager.camera.zoom_target = GameManager.camera.standard_zoom_level
	
	visualizer.update()

func _spawn_player(at_position: Vector2) -> void:
	# Load and instantiate player scene
	var player_scene = preload("res://Entities/Characters/Player/PlayerCharacter.tscn")
	var player = player_scene.instantiate() as EntityPlayer
	
	# Position the player and make em jump6
	player.global_position = at_position
	player.velocity = Vector2(0.0, -125.0)
	
	# Add to scene
	get_tree().root.add_child(player)
	
	# Register with GameManager
	GameManager.player = player

func _is_ship_grounded() -> bool:
	var space_state = get_world_2d().direct_space_state
	var ship_half_height = 22.0
	
	var ground_tolerance = 2.0
	
	var ray_length = ship_half_height + ground_tolerance
	
	var ray_query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2.DOWN * ray_length
	)
	ray_query.collision_mask = 1
	ray_query.exclude = [self]
	
	var ray_result = space_state.intersect_ray(ray_query)
	
	return ray_result != null and ray_result.size() > 0
