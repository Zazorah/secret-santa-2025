class_name Transition
extends CanvasLayer

signal screen_filled
signal finished

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.modulate.a = 0.0
	
	# Do entrance
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.25)
	
	await tween.finished
	
	screen_filled.emit()
	
	# Pause
	await get_tree().create_timer(0.25).timeout
	
	# Do exit
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.25)
	
	await tween.finished
	
	finished.emit()
	
	queue_free()
