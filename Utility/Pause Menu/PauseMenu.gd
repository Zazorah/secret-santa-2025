class_name PauseMenu
extends CanvasLayer

## Defines and Controls the Pause Menu

# State
var can_die: bool = false
var cursor_index: int = 0
var highlighted_button: Button

# Node References
@onready var button_container := $"Menu/VBoxContainer/Button Container"

# Button Definitions
var options = [
	{
		"title": "Resume Game",
		"on_pick": func(): _resume()
	},
	{
		"title": "Return to Checkpoint",
		"on_pick": func(): pass
	},
	{
		"title": "Exit Game",
		"on_pick": func(): get_tree().quit()
	}
]

func _ready() -> void:
	# Clear buttons from container.
	for child in button_container.get_children():
		child.queue_free()
	
	# Instantiate buttons.
	for i in range(len(options)):
		var option = options[i]
		
		# Skip the exit game option if playing on the web port.
		if option.title == "Exit Game" and GameManager.platform == GameManager.Platforms.WEB:
			continue
		
		# Instantiate and add to container.
		const BUTTON_SCENE := preload("res://Utility/Pause Menu/PauseMenuButton.tscn")
		var button = BUTTON_SCENE.instantiate() as Button
		button_container.add_child(button)
		
		var label = button.get_child(0) as RichTextLabel
		label.text = option.title
		
		# Connect to click event.
		button.pressed.connect(func(): _on_button_picked(i))
	
	
	# Wait a bit before allowing pausing again.
	await get_tree().create_timer(0.01).timeout
	can_die = true
	
	_update_highlighted_button()

func _on_button_picked(index: int) -> void:
	var callable = options[index].get("on_pick") as Callable
	if callable:
		callable.call()

func _input(event: InputEvent) -> void:
	# Move through buttons vertically.
	if event.is_action_pressed("interact"): # Up/W
		if cursor_index > 0:
			cursor_index -= 1
			_update_highlighted_button()
	
	if event.is_action_pressed("exit_ship"): # Down/S
		if cursor_index < button_container.get_child_count() - 1:
			cursor_index += 1
			_update_highlighted_button()
	
	if event.is_action_pressed("pause"):
		_resume()

func _update_highlighted_button() -> void:
	highlighted_button = button_container.get_child(cursor_index)
	highlighted_button.grab_focus()

func _press_highlighted_button() -> void:
	_on_button_picked(cursor_index)

func _resume() -> void:
	if can_die:
		GameManager.unpause_game()
		queue_free()
