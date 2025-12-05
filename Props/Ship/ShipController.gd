class_name ShipController
extends RigidBody2D

# State
var piloted := false # Currently being piloted by the player.

# Node References
@onready var sprite: Sprite2D = $Body/Sprite2D

# Constant Properties
const SL_SPRITE_LOOKUP := {
	1: preload("res://Props/Ship/Assets/Ship_S1.png"),
	2: preload("res://Props/Ship/Assets/Ship_S2.png"),
	3: preload("res://Props/Ship/Assets/Ship_S3.png"),
	4: preload("res://Props/Ship/Assets/Ship_S4.png")
}

func _ready() -> void:
	# Set collision properties.
	collision_layer = 4
	
	update_sprite()

# Update sprite based on current star level.
func update_sprite() -> void:
	if GameManager.star_data:
		var current_rank = GameManager.star_data.star_rank
		sprite.texture = SL_SPRITE_LOOKUP[current_rank]
