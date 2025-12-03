class_name DialogTextbox
extends Control

## Represents the textbox in the Dialog UI.

# State
var current_line: DialogLine
var line_index: int = 0
var active: bool = true
var is_writing: bool = false

# Child References
@onready var text_label: RichTextLabel = %RichTextLabel

func _process(_delta: float) -> void:
	# Do Typewriter effect.
	if line_index < current_line.text.length():
		line_index += 1
		is_writing = true
	else:
		is_writing = false
	
	# Update text contents
	text_label.visible_characters = max(line_index, 0)

func set_line(new_line: DialogLine) -> void:
	current_line = new_line
	text_label.text = current_line.text
	
	# Reset line for typewriter effect. Negative to give buffer time.
	line_index = -1
