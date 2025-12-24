extends Control

## Controller class for the Title Screen UI.

# Root references
@onready var credits_root := $Credits
@onready var menu_root := $Menu

# Node references 
@onready var logo = $Menu/Logo
@onready var button_container := $"Menu/Options/Button Container"

# State
var inputs_enabled: bool = false
var cursor_index: int = 0
var highlighted_button: Button

func _ready() -> void:
	# Hide both node-types
	credits_root.modulate.a = 0.0
	menu_root.modulate.a = 0.0
	
	# Begin playing animation.
	var logo_spr = logo.get_child(0) as AnimatedSprite2D
	if logo_spr:
		logo_spr.play("default")

	# Do entrance animation
	await get_tree().create_timer(0.25).timeout
	await _do_credits_entrance()
	await get_tree().create_timer(0.5).timeout
	await _do_credits_exit()
	await get_tree().create_timer(0.5).timeout
	await _do_menu_entrance()
	
	_setup_buttons()
	_enable_controls()

func _input(event: InputEvent) -> void:
	if not inputs_enabled:
		return
	
	if event.is_action_pressed("move_left"): # A/Left
		if cursor_index > 0:
			cursor_index -= 1
			_update_highlighted_button() 
	
	if event.is_action_pressed("move_right"): # D/Right
		if cursor_index < button_container.get_child_count() - 1:
			cursor_index += 1
			_update_highlighted_button()

func _do_credits_entrance() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(credits_root, "modulate:a", 1.0, 1.0)
	
	await tween.finished

func _do_credits_exit() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(credits_root, "modulate:a", 0.0, 1.0)
	
	await tween.finished

func _do_menu_entrance() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(menu_root, "modulate:a", 1.0, 1.0)
	
	await tween.finished

func _do_menu_exit() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(menu_root, "modulate:a", 0.0, 1.0)
	
	await tween.finished

func _setup_buttons() -> void:
	# Begin Button
	var begin_button = $"Menu/Options/Button Container/Begin Option"
	begin_button.pressed.connect(
		func():
			GameManager.begin_new_game()
			inputs_enabled = false
			
			# HACK - Wait a set amount of time and then die.
			await get_tree().create_timer(0.5).timeout
			queue_free()
	)
	
	# Credits Button
	var credits_button = $"Menu/Options/Button Container/Credits Option"
	credits_button.pressed.connect(
		func():
			print("Showing Credits!")
	)
	
	# Exit Button
	var exit_button = $"Menu/Options/Button Container/Exit Option"
	exit_button.pressed.connect(
		func():
			get_tree().quit()
	)

func _enable_controls() -> void:
	inputs_enabled = true
	_update_highlighted_button()

func _update_highlighted_button() -> void:
	highlighted_button = button_container.get_child(cursor_index)
	highlighted_button.grab_focus()
