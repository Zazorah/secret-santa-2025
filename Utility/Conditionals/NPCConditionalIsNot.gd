class_name ConditionalIsNot
extends Conditional

# Returns true if the value in global state is not the same as the value requested.
# Returns false if the value does not exist.

@export var key: StringName
@export var expected_value: Variant

func execute() -> bool:
	if GameManager.flags.has(key):
		return GameManager.flags.get(key) != expected_value
	
	return false
