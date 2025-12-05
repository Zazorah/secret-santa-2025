class_name ShipVisualizer
extends Node2D

# Node References
var ship: ShipController
@onready var sprite: Sprite2D = $Sprite2D

# Constant Properties
const SL_SPRITE_LOOKUP := {
	1: preload("res://Props/Ship/Assets/Ship_S1.png"),
	2: preload("res://Props/Ship/Assets/Ship_S2.png"),
	3: preload("res://Props/Ship/Assets/Ship_S3.png"),
	4: preload("res://Props/Ship/Assets/Ship_S4.png")
}

const SL_SPRITE_PILOT_LOOKUP := {
	1: preload("res://Props/Ship/Assets/Ship_S1_Piloted.png"),
	2: preload("res://Props/Ship/Assets/Ship_S2_Piloted.png"),
	3: preload("res://Props/Ship/Assets/Ship_S3_Piloted.png"),
	4: preload("res://Props/Ship/Assets/Ship_S4_Piloted.png")
}

func update() -> void:
	if GameManager.star_data and ship:
		if ship.piloted:
			sprite.texture = SL_SPRITE_PILOT_LOOKUP[ship.health]
		else:
			sprite.texture = SL_SPRITE_LOOKUP[ship.health]
