class_name EntityVisualizer
extends AnimatedSprite2D

## Node for displaying an NPCs appearance.

# Linked Nodes
var entity: Entity

# Animation
@export var sprite: SpriteFrames

func update_animation(velocity: Vector2, is_on_ground: bool) -> void:
	pass
