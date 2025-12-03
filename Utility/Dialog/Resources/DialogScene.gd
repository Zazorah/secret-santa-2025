class_name DialogScene
extends Resource

## Resource that represents a scene of dialog.

var tag: StringName
var lines: Array[DialogLine]

func _init(new_tag: StringName) -> void:
	tag = new_tag

# Returns the next line in sequence, or 
func get_next_line():
	if lines.size() > 0:
		var top = lines.pop_front()
		return top
