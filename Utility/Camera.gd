class_name Camera
extends Camera2D

## Camera controller.

# Focus
var focus_target: Node2D
@export var focus_speed: float = 50.0

# Zoom
var zoom_target: float = 1.0
var zoom_step: float = 0.10
var zoom_min: float = 0.20
var zoom_max: float = 3.00
@export var zoom_speed: float = 5.0

# Zoom Levels
const standard_zoom_level: float = 1.0
const vehicle_zoom_level: float = 0.5
const vehicle_flying_zoom_level: float = 0.33

# Offset
const standard_offset := Vector2(0.0, -36.0)
const speaking_offset := Vector2(0.0, -72.0)
var offset_target := standard_offset

# Debug
@export var debug: bool = false

func _ready() -> void:
	GameManager.camera = self
	offset = offset_target

func _input(event: InputEvent) -> void:
	if not debug:
		return
	
	if event.is_action_pressed("zoom_in"):
		zoom_target = max(zoom_min, zoom_target - zoom_step)
	if event.is_action_pressed("zoom_out"):
		zoom_target = min(zoom_max, zoom_target + zoom_step)

func _physics_process(delta: float) -> void:
	# Approach focus point.
	if not focus_target:
		return
	
	zoom = zoom.lerp(Vector2(zoom_target, zoom_target), zoom_speed * delta)
	
	var camera_size = get_viewport_rect().size / zoom
	var target_position = focus_target.global_position - (camera_size/2.0)
	
	global_position = global_position.lerp(target_position, focus_speed * delta)
	
	offset = offset.lerp(offset_target, 0.125)

func snap_to_target() -> void:
	var camera_size = get_viewport_rect().size / zoom
	global_position = focus_target.global_position - (camera_size/2.0)
