class_name ConditionalAnd
extends Conditional

# Groups Conditionals and executes true if all of them return true.

@export var conditions: Array[Conditional] 

func execute() -> bool:
	for condition in conditions:
		if not condition.execute():
			return false
	
	return true
