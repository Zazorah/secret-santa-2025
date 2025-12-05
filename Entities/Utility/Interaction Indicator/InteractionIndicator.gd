class_name InteractionIndicator
extends Control

# State
var shown := false
var distance_target: float

# Child References
@onready var root: Control = $Root
@onready var texture: TextureRect = $Root/Texture

# Animation Properties
const TWEEN_SPD = 0.25
const ROT_START = -125.0
const ROT_MIDDLE = 0.0
const ROT_END = 125.0
const DISTANCE_STEP = 32.0 # Amount the distance changes during entrance/exit.

func _ready() -> void:
	# Store current Y as distance target
	distance_target = texture.position.y
	
	# Hide Until Revealed
	modulate.a = 0.0

func reveal() -> void:
	if !shown:
		_do_entrance()
		shown = true

func disappear() -> void:
	if shown:
		_do_exit()
		shown = false

func _do_entrance() -> void:
	# Set starting properties
	modulate.a = 0.0
	root.rotation_degrees = ROT_START
	texture.position.y = distance_target + DISTANCE_STEP
	
	# Setup tween properties
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_parallel(true)
	
	# Rotate towards center.
	tween.tween_property(root, "rotation_degrees", ROT_MIDDLE, TWEEN_SPD)
	
	# Fade in.
	tween.tween_property(self, "modulate:a", 1.0, TWEEN_SPD)
	
	# Move Outwards
	tween.tween_property(texture, "position:y", distance_target, TWEEN_SPD)

func _do_exit() -> void:
	# Set starting properties
	modulate.a = 1.0
	root.rotation_degrees = ROT_MIDDLE
	texture.position.y = distance_target
	
	# Setup tween properties
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_parallel(true)
	
	# Rotate towards center.
	tween.tween_property(root, "rotation_degrees", ROT_END, TWEEN_SPD)
	
	# Fade in.
	tween.tween_property(self, "modulate:a", 0.0, TWEEN_SPD)
	
	# Move Outwards
	tween.tween_property(texture, "position:y", distance_target + DISTANCE_STEP, TWEEN_SPD)
