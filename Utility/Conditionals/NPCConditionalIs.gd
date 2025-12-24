class_name ConditionalIs
extends Conditional

# Returns true if the value in global state is the same as the value requested.

@export var key: StringName
@export var expected_value: Variant

func execute() -> bool:
	if GameManager.flags.has(key):
		return GameManager.flags.get(key) == expected_value
	
	return false
