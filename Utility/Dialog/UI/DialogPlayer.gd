class_name DialogPlayer
extends CanvasLayer

## UI controller and display root for a dialog scene.
## Instantiated with a key pointing to a dialog scene.

var scene: DialogScene

func _init(new_scene: DialogScene) -> void:
	scene = new_scene

func _ready() -> void:
	print(scene)
