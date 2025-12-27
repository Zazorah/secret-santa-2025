class_name EntityNPC
extends Entity

## Entity class that encapsulates basic NPC behavior.

# Cutscenes
# NOTE - For now, just reference a specific scene with a key. In the future
#        we'll introduce a more elaborate system that picks the key based on
#        different conditions.
@export var cutscene_name: StringName
@export var cutscene_keys: Array[CutsceneKey]

# Conditionals
@export var condition: Conditional

# State
enum State {IDLE, WANDERING, TALKING, WATCHING}
var current_state: State = State.IDLE

# Wandering
@export var will_wander: bool = false
@export var wander_radius: float = 100.0
@export var wander_speed: float = 50.0
@export var wander_idle_time_min: float = 2.0
@export var wander_idle_time_max: float = 5.0

var wander_timer: float
var wander_target: Vector2
var spawn_position: Vector2
var wander_tolerance: float = 5.0

# Watching
@export var watching_tolerance: float = 32.0

# Talking State
var current_textbox: DialogTextbox
var is_talking: bool

# Interaction Zone
@onready var interaction_zone: InteractionZone = $InteractionZone

func _ready():
	super._ready()
	
	# Ensure conditions are met. If not, despawn immediately.
	if condition:
		if not condition.execute():
			queue_free()
			return
	
	# Set Collision Properties
	collision_layer = 2
	collision_mask = 1
	
	# Set up interactions.
	if cutscene_keys and interaction_zone:
		interaction_zone.interacted.connect(func (_node):
			GameManager.interaction_queue.push_front({
				"method": func(): _on_interact(null),
				"priority": 1
			})
		)
	
	wander_timer = randf_range(wander_idle_time_min, wander_idle_time_max)
	

func _process(delta: float) -> void:
	# Interrupt state and begin watching if near player.
	if not current_state == State.TALKING and not current_state == State.WATCHING:
		if _is_near_player():
			change_state(State.WATCHING)

	# Update based on state.
	match current_state: 
		State.IDLE:
			_process_idle(delta)
		State.WANDERING:
			_process_wandering(delta)
		State.WATCHING:
			_process_watching(delta)
		State.TALKING:
			_process_talking()

func update_velocity(delta: float):
	if current_state == State.WANDERING:
		var direction = sign(wander_target.x - global_position.x)
		if direction != 0:
			velocity.x = direction * wander_speed
		else:
			velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, 200.0 * delta)

# State Management Methods
func change_state(new_state: State) -> void:
	_on_state_exit(current_state)
	_on_state_enter(new_state)
	
	current_state = new_state

func _on_state_enter(state: State) -> void:
	match state:
		State.IDLE:
			velocity.x = 0
			wander_timer = randf_range(wander_idle_time_min, wander_idle_time_max)
		State.WANDERING:
			wander_timer = randf_range(wander_idle_time_min, wander_idle_time_max)
		State.WATCHING:
			velocity.x = 0
		_:
			pass

func _on_state_exit(state: State) -> void:
	match state:
		State.WANDERING:
			velocity.x = 0
		_:
			pass

func _process_idle(delta: float) -> void:
	if not will_wander:
		return
	
	wander_timer -= delta
	if wander_timer <= 0:
		# Try to find a wander target
		if _find_valid_wander_target():
			change_state(State.WANDERING)
		else:
			wander_timer = randf_range(wander_idle_time_min, wander_idle_time_max)

func _process_wandering(_delta: float) -> void:
	if abs(global_position.x - wander_target.x) <= wander_tolerance:
		change_state(State.IDLE)
		return

func _process_watching(_delta: float) -> void:
	if visualizer and GameManager.player:
		visualizer.face_direction(GameManager.player.global_position)
	
	if not _is_near_player():
		change_state(State.IDLE)

func _process_talking() -> void:
	if current_textbox:
		if current_textbox.is_writing and visualizer.animation != "talk":
			visualizer.play_animation("talk")
		elif not current_textbox.is_writing:
			visualizer.play_animation("idle")

# Path-finding methods for Wandering state
func _find_valid_wander_target() -> bool:
	const MAX_ATTEMPTS = 10
	
	for attempt in MAX_ATTEMPTS:
		var random_offset = randf_range(-wander_radius, wander_radius)
		var potential_target = spawn_position + Vector2(random_offset, 0)
		
		if _is_valid_wander_position(potential_target):
			wander_target = potential_target
			return true
	
	return false

func _is_valid_wander_position(target_pos: Vector2) -> bool:
	if abs(target_pos.x - global_position.x) < wander_tolerance * 2:
		return false
	
	var direction = sign(target_pos.x - global_position.x)
	var distance = abs(target_pos.x - global_position.x)
	
	if not _is_path_clear(direction, distance):
		return false
	
	return true

func _is_path_clear(direction: int, distance: float) -> bool:
	var space_state = get_world_2d().direct_space_state
	var start_pos = global_position
	var end_pos = global_position + Vector2(direction * distance, 0)
	
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collision_mask = 1 # Only check world layer
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	
	return result.is_empty()

func _get_cutscene_key() -> Variant:
	for key_check in cutscene_keys:
		if key_check and key_check.check_conditions():
			return key_check.key
	
	return null

func _on_interact(_node: Node2D) -> void:
	var _key = _get_cutscene_key()
	
	if not _key:
		return
	
	if DialogManager.has_scene(_key):
		# Alter interacter and NPC state.
		var prev_state = current_state
		change_state(State.TALKING)
		
		var prev_player_state = null
		if GameManager.player:
			prev_player_state = GameManager.player.current_state
			GameManager.player.current_state = EntityPlayer.State.TALKING
		
		# Begin dialog sequence.
		var player = DialogManager.play_dialog(_key)
		
		await player.setup_complete
		
		# Grab hold of Textbox
		current_textbox = player.textbox
		
		await player.finished
		
		# Reset states.
		change_state(prev_state)
		
		if GameManager.player:
			GameManager.player.current_state = prev_player_state

# Utility Methods
func _is_near_player() -> bool:
	if GameManager.player:
		if abs(global_position.x - GameManager.player.global_position.x) <= watching_tolerance:
			return true
	
	return false
