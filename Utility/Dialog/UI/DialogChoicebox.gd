class_name DialogChoicebox
extends Control

## Represents a list of choices in the Dialog UI.

var choices: Array[DialogChoice]

func set_choices(new_choices: Array[DialogChoice]) -> void:
	choices = new_choices
