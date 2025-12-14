extends Node

## Autoload manager of global game-state as well as saving/loading data.

# Player
var player: EntityPlayer

# Camera
var camera: Camera

# Data
var ship_data: ShipData
var star_data: StarData

# Interaction Queue
var interaction_queue: Array[Variant]

func _ready() -> void:
	# NOTE - Check if the game has some loadable save here.
	#        Just loading a new game for now.
	create_new_game()

func _process(delta: float) -> void:
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
