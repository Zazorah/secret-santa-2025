extends Node

## Autoload manager of global game-state

# Player
var player: Node2D

# Camera
var camera: Camera 

func _ready() -> void:
	DialogManager.play_dialog("choice_test")
