class_name TractorBeamVisualizer
extends Node2D

# State
var controller: TractorBeamController
var ship_visualizer: ShipVisualizer

# Children
@onready var sprite = $Sprite

func _ready() -> void:
	# Connect to parent controller.
	var parent = get_parent()
	if parent is TractorBeamController:
		controller = parent
	else:
		push_error("Unable to find parent.")
		queue_free()

func _process(_delta: float) -> void:
	# Visualize when beam is active.
	if controller:
		sprite.visible = controller.active
		
		if controller.ship:
			var visualizer = controller.ship.visualizer
			rotation_degrees = lerp(rotation_degrees, visualizer.rotation_degrees, 0.05)
