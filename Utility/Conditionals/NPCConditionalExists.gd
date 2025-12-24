class_name ConditionalExists
extends Conditional

# Returns true if a value of a given key exists in global state.

@export var key: StringName
@export var expected_value: Variant

func execute() -> bool:
	if GameManager.flags.has(key):
		return GameManager.flags.get(key) != expected_value
	
	return false
