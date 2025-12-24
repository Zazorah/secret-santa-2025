class_name PauseMenu
extends CanvasLayer

var can_die: bool = false

func _ready() -> void:
	# Wait a bit before allowing pausing again.
	await get_tree().create_timer(0.1).timeout
	can_die = true

func _input(event: InputEvent) -> void:
	if can_die and event.is_action_pressed("pause"):
		GameManager.unpause_game()
		queue_free()
