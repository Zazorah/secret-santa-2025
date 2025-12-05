class_name ShipData
extends Resource

## Data manager for Ship Data.
@export var can_enter := true # Whether the ship can be entered.

signal status_updated

func toggle_entry() -> void:
	can_enter = not can_enter
	status_updated.emit()
