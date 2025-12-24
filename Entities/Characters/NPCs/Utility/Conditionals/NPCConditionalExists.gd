class_name NPCConditionalIsNot
extends NPCConditional

# Returns true if a value of a given key exists in global state.

@export var key: StringName
@export var expected_value: Variant

func execute() -> bool:
	if GameManager.state.has(key):
		return GameManager.state.get(key) != expected_value
	
	return false
