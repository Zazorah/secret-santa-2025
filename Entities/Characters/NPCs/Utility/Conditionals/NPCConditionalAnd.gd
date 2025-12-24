class_name NPCConditionalAnd
extends NPCConditional

# Groups Conditionals and executes true if all of them return true.

@export var conditions: Array[NPCConditional] 

func execute() -> bool:
	for condition in conditions:
		if not condition.execute():
			return false
	
	return true
