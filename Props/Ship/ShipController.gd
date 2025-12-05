class_name ShipController
extends RigidBody2D

# State
var piloted := false # Currently being piloted by the player.

# Node References
@onready var sprite: Sprite2D = $Body/Sprite2D
@onready var interaction_zone: InteractionZone = $InteractionZone

# Stats
var health = 1

# Constant Properties
const SL_SPRITE_LOOKUP := {
	1: preload("res://Props/Ship/Assets/Ship_S1.png"),
	2: preload("res://Props/Ship/Assets/Ship_S2.png"),
	3: preload("res://Props/Ship/Assets/Ship_S3.png"),
	4: preload("res://Props/Ship/Assets/Ship_S4.png")
}

const SL_SPRITE_PILOT_LOOKUP := {
	1: preload("res://Props/Ship/Assets/Ship_S1_Piloted.png"),
	2: preload("res://Props/Ship/Assets/Ship_S2_Piloted.png"),
	3: preload("res://Props/Ship/Assets/Ship_S3_Piloted.png"),
	4: preload("res://Props/Ship/Assets/Ship_S4_Piloted.png")
}

func _ready() -> void:
	# Set collision properties.
	collision_layer = 4
	
	# Setup interactions
	interaction_zone.interacted.connect(_enter_ship)
	
	update_visual_state()

func _process(delta: float) -> void:
	if not piloted:
		# Do auto-heal.
		pass
	
	if piloted and _is_ship_grounded():
		if Input.is_action_just_pressed("exit_ship"):
			_exit_ship()
	
	# Placeholder Input
	if piloted and Input.is_action_just_pressed("jump"):
		linear_velocity += Vector2(500.0 * randf_range(-1.0, 1.0), -500.0)

# Update sprite based on current health level.
func update_visual_state() -> void:
	if GameManager.star_data:
		if piloted:
			sprite.texture = SL_SPRITE_PILOT_LOOKUP[health]
		else:
			sprite.texture = SL_SPRITE_LOOKUP[health]

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
	
	update_visual_state()

func _exit_ship() -> void:
	if not piloted:
		return
	
	# Set not piloted
	piloted = false
	
	# Stop Velocity
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
		
	# Find closest ground position
	var spawn_position = _find_closest_ground_position()
	
	# Spawn player at the position
	if spawn_position:
		_spawn_player(spawn_position)
	else:
		# Fallback: spawn at ship position if no ground found
		_spawn_player(global_position)
	
	# Update camera focus to player
	if GameManager.camera and GameManager.player:
		GameManager.camera.focus_target = GameManager.player
		GameManager.camera.zoom_target = GameManager.camera.standard_zoom_level
	
	update_visual_state()

func _find_closest_ground_position() -> Vector2:
	# Get the physics space
	var space_state = get_world_2d().direct_space_state
	
	# Create a shape query to find nearby colliders on layer 1
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 200.0 # Search radius - adjust as needed
	query.shape = shape
	query.transform = global_transform
	query.collision_mask = 1 # Layer 1
	query.exclude = [self] # Don't collide with ship itself
	
	# Find overlapping bodies
	var results = space_state.intersect_shape(query, 32)
	
	if results.is_empty():
		return Vector2.ZERO
	
	# Find the closest point among all colliding bodies
	var closest_point = Vector2.ZERO
	var closest_distance = INF
	
	for result in results:
		# Raycast down from ship position to find surface point
		var ray_query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + Vector2.DOWN * 500 # Cast downward
		)
		ray_query.collision_mask = 1
		ray_query.exclude = [self]
		
		var ray_result = space_state.intersect_ray(ray_query)
		
		if ray_result:
			var distance = global_position.distance_to(ray_result.position)
			if distance < closest_distance:
				closest_distance = distance
				# Offset slightly above the surface
				closest_point = ray_result.position + ray_result.normal * 10.0
	
	return closest_point if closest_point != Vector2.ZERO else global_position

func _spawn_player(at_position: Vector2) -> void:
	# Load and instantiate player scene
	var player_scene = preload("res://Entities/Characters/Player/PlayerCharacter.tscn")
	var player = player_scene.instantiate()
	
	# Position the player
	player.global_position = at_position
	
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
