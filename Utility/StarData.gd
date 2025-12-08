class_name StarData
extends Resource

## Data object for tracking star count and rank.

@export var star_rank = 3 # Ranges from 1 - 4
@export var star_count = 0
@export var constellation_count = 0

const RANK_MAX = 4

signal rank_increased(new_rank) 

func increase_rank() -> void:
	star_rank = min(RANK_MAX, star_rank + 1)
	rank_increased.emit(star_rank)

func add_star(star: Variant) -> void:
	pass
