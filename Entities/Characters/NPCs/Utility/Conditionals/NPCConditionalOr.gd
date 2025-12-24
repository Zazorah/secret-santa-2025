class_name NPCConditionalOr
extends NPCConditional

# Groups Conditionals and executes true if any of them return true.

@export var conditions: Array[NPCConditional] 

func execute() -> bool:
	for condition in conditions:
		if condition.execute():
			return true
	
	return false
