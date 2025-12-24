class_name ConditionalOr
extends Conditional

# Groups Conditionals and executes true if any of them return true.

@export var conditions: Array[Conditional] 

func execute() -> bool:
	for condition in conditions:
		if condition.execute():
			return true
	
	return false
