class_name NPCConditionalIs
extends NPCConditional

# Returns true if the value in global state is the same as the value requested.

@export var key: StringName
@export var expected_value: Variant

func execute() -> bool:
	if GameManager.state.has(key):
		return GameManager.state.get(key) == expected_value
	
	return false
