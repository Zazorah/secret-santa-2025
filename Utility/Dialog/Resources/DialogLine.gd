class_name DialogLine
extends Resource

## Represents an individual line of dialogue.

var text: String # Text to display for this dialog line. 
var choices: Array[DialogChoice] # List of choices attached to a dialog line.

enum BubbleVariant {
	DEFAULT, # The default text bubble used for most NPCs and dialogue.
	EVIL,    # Text bubble used for villainous characters.
	SAD,     # Text bubble used for someone experiencing a bad dream.
}

const bubble_textures := {
	BubbleVariant.DEFAULT: preload("res://Utility/Dialog/UI/Textbox/Assets/TextBubble_Default.tres"),
	BubbleVariant.EVIL: preload("res://Utility/Dialog/UI/Textbox/Assets/TextBubble_Evil.tres"),
	BubbleVariant.SAD: preload("res://Utility/Dialog/UI/Textbox/Assets/TextBubble_Sad.tres")
}

var variant: Variant = BubbleVariant.DEFAULT
