extends Node

## Autoload manager of global game-state as well as saving/loading data.

# Player
var player: EntityPlayer

# Camera
var camera: Camera

# Platform
enum Platforms {
	EXE, # Game is running from an executable program on a computer.
	WEB  # Game is running in a web browser.
}

var platform = Platforms.EXE

# State
enum GameState {
	NORMAL,  # Entites act and animate as normal.
	PAUSED,  # Entites are frozen and cannot act.
	STANDBY  # Entities can act, but the player will not respond to inputs.
}

signal state_changed(state)

var state = GameState.NORMAL: # Global state representation. Controls entity flow.
	# Emit new state as a signal when changed.
	set(val):
		state_changed.emit(val)
		state = val
var flags: Dictionary # Generic global state object.
var can_pause: bool = true # Whether the game can currently be paused by the player.

# Data
var ship_data: ShipData
var star_data: StarData

# Map Data
var current_area: StringName
var spawn_tag: StringName = "door_test_a"
var current_room: Room

const AREA_UI := preload("res://Utility/Area Overlay/AreaOverlay.tscn")

# Interaction Queue
var interaction_queue: Array[Variant]

func _ready() -> void:
	# NOTE - Check if the game has some loadable save here.
	#        Just loading a new game for now.
	create_new_game()

func _process(_delta: float) -> void:
	# Action Queue
	var action = null
	while interaction_queue.size() > 0:
		var top = interaction_queue.pop_front()
		if not action or action.priority < top.priority:
			action = top
	
	if action:
		action.method.call()

# Set up global state to act as a new save. 
func create_new_game() -> void:
	ship_data = ShipData.new()
	star_data = StarData.new()

# Save the game state to a loadable file.
func save_game() -> void:
	pass

# Load the game state from a file.
func load_game() -> void:
	pass

# Pause the Game and optionally show a menu.
func pause_game(show_menu: bool = true) -> void:
	state = GameState.PAUSED
	
	if show_menu:
		const MENU_SCENE := preload("res://Utility/Pause Menu/PauseMenu.tscn")
		var menu = MENU_SCENE.instantiate() as PauseMenu
		
		add_child(menu)

func unpause_game() -> void:
	state = GameState.NORMAL
	
	# Prevent pausing again for a little.
	can_pause = false
	await get_tree().create_timer(0.1).timeout
	can_pause = true

func set_area(new_area: StringName) -> void:
	var show_ui = new_area != current_area
	current_area = new_area
	
	if show_ui:
		var indicator = AREA_UI.instantiate()
		add_child(indicator)

func load_room(room: Node2D) -> void:
	if room is not Room:
		push_warning("The room attempting to be loaded is not a room. Attempting load anyway.")
	
	if current_room:
		current_room.queue_free()
	
	current_room = room as Room
	get_tree().root.add_child(current_room)
	
	GameManager.state = GameManager.GameState.NORMAL
