class_name ConstellationPointController
extends Node2D

@export var constellation_key: StringName

const STAR_SCENE := preload("res://Props/Stars/PropStar.tscn")

enum State { EMPTY, FILLED }
var current_state = State.EMPTY

@onready var area: Area2D = $DetectionArea

func _ready() -> void:
	if constellation_key:
		if GameManager.star_data.constellation_point_is_set(constellation_key):
			_prefill()
	else:
		push_warning(
			"Constellation Point was instantiated without a set constellation_key.
			Only let this slide in a testing environment."
		)
	
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(node: Node2D) -> void:
	if current_state != State.EMPTY:
		# Don't respond to new states at all.
		return
	
	if node is StarController:
		_connect_to_star(node)
		_switch_state(State.FILLED)

func _connect_to_star(star: StarController) -> void:
	GameManager.star_data.set_constellation_point(constellation_key, star.star_key)
	star.set_hover_target(self)

func _prefill() -> void:
	var star_key = GameManager.star_data.constellation_point_get_key(constellation_key)
	
	var star = STAR_SCENE.instantiate() as StarController
	star.star_key = star_key
	star.set_hover_target(self)
	add_child(star)

func _switch_state(new_state: State) -> void:
	if new_state != current_state:
		_on_exit(current_state)
		_on_enter(new_state)
	
	current_state = new_state

func _on_enter(state: State) -> void:
	pass

func _on_exit(state: State) -> void:
	pass
