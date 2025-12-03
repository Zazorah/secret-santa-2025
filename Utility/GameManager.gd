extends Node

## Autoload manager of global game-state

# Camera
var camera: Camera 

func _ready() -> void:
	var player = DialogManager.play_dialog("axolotl_test")
