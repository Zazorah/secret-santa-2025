class_name DialogScene
extends Resource

## Resource that represents a scene of dialog.

var tag: StringName
var lines: Array[DialogLine]

func _init(new_tag: StringName) -> void:
	tag = new_tag

# Returns the line at a given index, or null. 
func get_line(index: int):
	if lines.size() > index:
		return lines[index]
	
	return null
