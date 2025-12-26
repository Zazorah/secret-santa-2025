class_name DialogLoader
extends RefCounted

## Class used for loading dialog data from the database.

# Database Path
const folder_path = "res://Utility/Dialog/Data/"

# State
var dialog_loaded: bool = false
var dialog_data: Dictionary[String, DialogScene]

# Loads all JSON cutscene data into memory.
func load_dialog() -> void:
	var dir = DirAccess.open(folder_path)
	
	if dir == null:
		push_error("Failed to open directory: " + folder_path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		# Skip directories
		# NOTE - In the future, it might be good to expand this for recursive
		#        reading from folders.
		if not dir.current_is_dir():
			if file_name.get_extension().to_lower() == "json":
				var full_path = folder_path.path_join(file_name)
				var json_data = _load_json_data(full_path)
				
				if json_data != null:
					_process_json_data(json_data)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	dialog_loaded = true

# Read the contents of a JSON file into a resource for further parsing.
func _load_json_data(file_path: String) -> Variant:
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		push_error("Failed to open file: ", file_path)
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		push_error("Failed to parse JSON in file: ", file_path)
		return
	
	return json.data

func _process_json_data(data: Variant) -> void:
	# Process each field as a DialogScene
	for key in data:
		var scene = DialogScene.new(key)
		
		# Process each line contained as a DialogLine and append it to the scene.
		for entry in data[key]:
			var line = _process_line(entry)
			scene.lines.push_back(line)
		
		dialog_data.set(key, scene)

func _process_line(line_data: Variant) -> DialogLine:
	var line = DialogLine.new()
	
	line.text = line_data.text
	
	if line_data.has("choices"):
		line.choices = _process_choices(line_data.choices)
	
	if line_data.has("variant") and line_data.variant is String:
		var key = line_data.variant.to_lower()
		match key:
			"sad":
				line.variant = DialogLine.BubbleVariant.SAD
			"evil":
				line.variant = DialogLine.BubbleVariant.EVIL
			_:
				line.variant = DialogLine.BubbleVariant.DEFAULT
	
	return line

func _process_choices(choices: Variant) -> Array[DialogChoice]:
	var result: Array[DialogChoice] = []
	
	for choice_data in choices:
		var choice = DialogChoice.new()
		choice.text = choice_data.text
		
		if choice_data.has("tag"):
			choice.tag = choice_data.tag
		
		result.push_back(choice)
	
	return result

func get_dialog(key: StringName) -> DialogScene:
	# Load dialog if not loaded.
	if not dialog_loaded:
		load_dialog()
	
	if not dialog_data.has(key):
		return
	
	var dialog_scene = dialog_data.get(key)
	return dialog_scene
