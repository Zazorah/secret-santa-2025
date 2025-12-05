extends Node

## Autoload manager of global game-state

# Camera
var camera: Camera 

func _ready() -> void:
	DialogManager.play_dialog("choice_test")
