class_name StarData
extends Resource

## Data object for tracking star count and rank.

var star_rank = 1 # Ranges from 1 - 4
var star_count = 0
var constellation_count = 0

var _collected_stars: Array[StringName]
var _constellation_points: Dictionary[StringName, StringName] = {
	"PrefillPointKey": "PrefillStarKey"
}

var _completed_groups: Array[bool]
var _constellation_groups: Array[Array] = [
	["TestPointA", "TestPointB", "TestPointC"]
]

const RANK_MAX = 4

signal rank_increased(new_rank)

func _init() -> void:
	_completed_groups.resize(_constellation_groups.size())
	print(_completed_groups)

func _check_groups_completed() -> void:
	for i in range(_completed_groups.size()):
		var group_status = _completed_groups[i]
		if not group_status:
			var group_data = _constellation_groups[i]
			var set_all = true
			
			for key in group_data:
				if not constellation_point_is_set(key):
					set_all = false
					break
			
			if set_all:
				_completed_groups[i] = true
				increase_rank()

func set_constellation_point(constellation_key: StringName, star_key: StringName) -> void:
	_constellation_points.set(constellation_key, star_key)
	_collected_stars.push_back(star_key)
	
	_check_groups_completed()

func star_is_collected(star_key: StringName) -> bool:
	return _collected_stars.has(star_key)

func constellation_point_get_key(constellation_key: StringName) -> StringName:
	return _constellation_points.get(constellation_key, "")

func constellation_point_is_set(constellation_key: StringName) -> bool:
	var constellation_point_filled = _constellation_points.get(constellation_key, "")
	return constellation_point_filled != ""

func increase_rank() -> void:
	print("We're Heroes..")
	
	star_rank = min(RANK_MAX, star_rank + 1)
	rank_increased.emit(star_rank)

func add_star(star: Variant) -> void:
	pass
