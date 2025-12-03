extends Node

## Autoload manager of global game-state

# Camera
var camera: Camera 

func _ready() -> void:
	var player = DialogManager.play_dialog("frog_test")
	await player.finished
	
	print("First scene finished!")
	
	var new_player = DialogManager.play_dialog("frog_test")
	await new_player.finished
	
	print("Second scene finished!")
