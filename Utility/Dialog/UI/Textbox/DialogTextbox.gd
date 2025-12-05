class_name DialogTextbox
extends Control

## Represents the textbox in the Dialog UI.

# State
var current_line: DialogLine
var can_advance: bool = false
var line_index: int = 0
var active: bool = true
var is_writing: bool = false

# Animation
var is_animating: bool
var animation_speed: float = 0.75

# Child References
@onready var text_label: RichTextLabel = %RichTextLabel

func _ready() -> void:
	_do_entrance()

func _do_entrance() -> void:
	is_animating = true
	
	# Set initial position.
	position.y = -64.0
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", 0.0, animation_speed)
	
	await tween.finished
	
	is_animating = false

func _do_exit() -> void:
	is_animating = true
	
	# Set initial position
	position.y = 0.0
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", -64.0, animation_speed)
	
	await tween.finished
	
	is_animating = false

func _process(_delta: float) -> void:
	# Do Typewriter effect.
	if not is_animating:
		if line_index < current_line.text.length():
			line_index += 1
			is_writing = true
		else:
			is_writing = false
	
	can_advance = not is_writing and not is_animating
	
	# Update text contents
	text_label.visible_characters = max(line_index, 0)

func set_line(new_line: DialogLine) -> void:
	current_line = new_line
	text_label.text = current_line.text
	
	# Reset line for typewriter effect. Negative to give buffer time.
	line_index = -1

func kill() -> void:
	await _do_exit()
	queue_free()
