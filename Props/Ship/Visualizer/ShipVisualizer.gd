class_name ShipVisualizer
extends Node2D

# Node References
var ship: ShipController
@onready var sprite: Sprite2D = $Sprite2D
@onready var flying_particle_emitter: GPUParticles2D = $FlyingParticleEmitter

# Rotation
var rot_target = 0.0

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

func _process(delta: float) -> void:
	rotation_degrees = lerp(rotation_degrees, rot_target, 0.05)

func reset_rotation() -> void:
	rot_target = 0.0
	rotation_degrees = 0.0

func update() -> void:
	if GameManager.star_data and ship:
		if ship.piloted:
			sprite.texture = SL_SPRITE_PILOT_LOOKUP[ship.health]
		else:
			sprite.texture = SL_SPRITE_LOOKUP[ship.health]
