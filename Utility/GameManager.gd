extends Node

## Autoload manager of global game-state as well as saving/loading data.

# Player
var player: EntityPlayer

# Camera
var camera: Camera

# Data
var ship_data: ShipData
var star_data: StarData

# Map Data
var current_area: StringName
var spawn_tag: StringName
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

func set_area(new_area: StringName) -> void:
	var show_ui = new_area != current_area
	current_area = new_area
	
	if show_ui:
		var indicator = AREA_UI.instantiate()
		add_child(indicator)
