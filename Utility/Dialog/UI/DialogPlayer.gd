class_name DialogPlayer
extends CanvasLayer

## UI controller and display root for a dialog scene.
## Instantiated with a key pointing to a dialog scene.

# Scene References
const TEXTBOX_SCENE = preload("res://Utility/Dialog/UI/Textbox/DialogTextbox.tscn")
const CHOICEBOX_SCENE = preload("res://Utility/Dialog/UI/Choicebox/DialogChoicebox.tscn")

# Emitted when all child nodes are ready.
signal setup_complete

# Emitted when the dialog scene is finished.
signal finished

# State
var scene: DialogScene
var current_line: DialogLine
var scene_index: int = -1

# UI Elements
var textbox: DialogTextbox
var choicebox: DialogChoicebox

func _init(new_scene: DialogScene) -> void:
	scene = new_scene

func _ready() -> void:
	# Create Textbox
	textbox = TEXTBOX_SCENE.instantiate() as DialogTextbox
	add_child(textbox)
	
	setup_complete.emit()
	
	# Begin on First Line
	_show_next_line()

func _show_next_line() -> void:
	scene_index += 1
	
	current_line = scene.get_line(scene_index)
	
	# If there is no next line, assume the cutscene is over.
	if not current_line:
		_end_dialog()
		return
	
	textbox.set_line(current_line)

func _show_choices(choices: Array[DialogChoice]) -> void:
	# Create Choicebox
	choicebox = CHOICEBOX_SCENE.instantiate() as DialogChoicebox
	add_child(choicebox)
	
	# Pass in choices
	choicebox.set_choices(choices)

func _hide_choices() -> void:
	pass

func _input(event: InputEvent) -> void:
	# Handle Textbox inputs
	if textbox.active and current_line:
		if not textbox.is_writing and event.is_action_pressed("advance_text"):
			# Show choices if they exist.
			if current_line.choices:
				_show_choices(current_line.choices)
			else:
				_show_next_line()

func _end_dialog() -> void:
	if textbox:
		await textbox.kill()
	
	finished.emit()
	queue_free()
