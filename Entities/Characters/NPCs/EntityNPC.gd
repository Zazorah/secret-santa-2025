class_name EntityNPC
extends Entity

## Entity class that encapsulates basic NPC behavior.

# Cutscenes
# NOTE - For now, just reference a specific scene with a key. In the future
#        we'll introduce a more elaborate system that picks the key based on
#        different conditions.
@export var cutscene_key: StringName

# State
enum State { IDLE, WANDERING, TALKING, WATCHING }
var current_state: State = State.IDLE 

# Wandering
@export var will_wander: bool = true
var wander_timer: float
var wander_target: Vector2

# Interaction Zone
var interaction_zone: InteractionZone 

func _ready():
	super._ready()
	
	# Set self up as something interactable if cutscene data exists.
	if cutscene_key:
		pass
	
	pass

func _process(delta: float) -> void:
	# Update based on state.
	match current_state:
		pass

# State Management Methods
func change_state(new_state: State) -> void:
	_on_state_exit(current_state)
	_on_state_enter(new_state)
	
	current_state = new_state

func _on_state_enter(state: State) -> void:
	pass

func _on_state_exit(state: State) -> void:
	pass

# Interaction Management Methods
func _setup_interaction_zone() -> void:
	pass
