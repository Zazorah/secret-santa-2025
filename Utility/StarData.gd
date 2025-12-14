class_name StarData
extends Resource

## Data object for tracking star count and rank.

var star_rank = 3 # Ranges from 1 - 4
var star_count = 0
var constellation_count = 0

var _collected_stars: Array[StringName]
var _constellation_points: Dictionary[StringName, StringName] = {
	"PrefillPointKey": "PrefillStarKey"
}

const RANK_MAX = 4

signal rank_increased(new_rank) 

func set_constellation_point(constellation_key: StringName, star_key: StringName) -> void:
	_constellation_points.set(constellation_key, star_key)
	_collected_stars.push_back(star_key)

func star_is_collected(star_key: StringName) -> bool:
	return _collected_stars.has(star_key)

func constellation_point_get_key(constellation_key: StringName) -> StringName:
	return _constellation_points.get(constellation_key, "")

func constellation_point_is_set(constellation_key: StringName) -> bool:
	var constellation_point_filled = _constellation_points.get(constellation_key, "")
	return constellation_point_filled != ""

func increase_rank() -> void:
	star_rank = min(RANK_MAX, star_rank + 1)
	rank_increased.emit(star_rank)

func add_star(star: Variant) -> void:
	pass
