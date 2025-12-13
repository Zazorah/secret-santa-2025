class_name TractorBeamVisualizer
extends Node2D

# State
var controller: TractorBeamController
var ship: ShipController

# Children
@onready var sprite = $Sprite

func _ready() -> void:
	# Connect to parent controller.
	if get_parent() is TractorBeamController:
		controller = get_parent()
	else:
		push_error("Unable to find parent.")
		queue_free()

func _process(delta: float) -> void:
	if controller:
		sprite.visible = controller.active
