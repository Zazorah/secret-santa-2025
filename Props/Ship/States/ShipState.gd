class_name ShipState
extends Node

var ship: ShipController

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func _will_respond_to_inputs() -> bool:
	return GameManager.state == GameManager.GameState.NORMAL
