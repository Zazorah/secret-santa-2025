class_name NPCConditional
extends Resource

## Resource used to set up conditional spawns for NPCs.
## See README for more.

func execute() -> bool:
	# In classes that extend this, override this method with your own
	# conditional logic.
	push_warning("Generic NPCConditional used.")
	return true
