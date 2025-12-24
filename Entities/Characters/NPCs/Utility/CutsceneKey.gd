class_name CutsceneKey
extends Resource

## Resource that defines the link between Conditionals and cutscene keys.
## If you'd like to just have a key, leave the condition blank.

@export var key: StringName
@export var condition: Conditional

func check_conditions() -> bool:
	return true 
