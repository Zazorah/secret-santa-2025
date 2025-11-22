class_name Camera
extends Camera2D

## Camera controller.

# Focus
var focus_target: Node2D
@export var focus_speed: float = 50.0

func _ready() -> void:
	GameManager.camera = self
	offset = Vector2(0.0, -36.0)

func _physics_process(delta: float) -> void:
	# Approach focus point.
	if not focus_target:
		return
	
	var camera_size = get_viewport_rect().size
	var target_position = focus_target.global_position - (camera_size/2.0)
	
	global_position = global_position.lerp(target_position, focus_speed * delta)
