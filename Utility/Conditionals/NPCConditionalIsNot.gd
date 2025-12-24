class_name ConditionalIsNot
extends Conditional

# Returns true if the value in global state is not the same as the value requested.
# Returns false if the value does not exist.

@export var key: StringName
@export var expected_value: Variant

func execute() -> bool:
	if GameManager.state.has(key):
		return GameManager.state.get(key) != expected_value
	
	return false
