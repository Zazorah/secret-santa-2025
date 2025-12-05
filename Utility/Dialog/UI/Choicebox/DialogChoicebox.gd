class_name DialogChoicebox
extends Control

## Represents a list of choices in the Dialog UI.

# Scene References
const OPTION_SCENE = preload("res://Utility/Dialog/UI/Choicebox/DialogChoiceboxOption.tscn")

# Drawing Properties
var container_padding := Vector2(4.0, 4.0)

# Child References
@onready var outer_container = %OuterContainer
@onready var inner_container = %InnerContainer
@onready var choice_container = %ChoiceContainer

var choices: Array[DialogChoice]

func set_choices(new_choices: Array[DialogChoice]) -> void:
	choices = new_choices
	
	clear_choices()
	
	# Add new choices.
	for choice in new_choices:
		var option = OPTION_SCENE.instantiate() as RichTextLabel
		option.text = " " + choice.text
		
		choice_container.add_child(option)

func clear_choices() -> void:
	if choice_container:
		for n in choice_container.get_children():
			n.queue_free()
