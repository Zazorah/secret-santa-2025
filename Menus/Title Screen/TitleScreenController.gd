extends Control

## Controller class for the Title Screen UI.

# Root references
@onready var credits_root := $Credits
@onready var menu_root := $Menu

# Node references 
@onready var logo = $Menu/Logo

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
