class_name EntityVisualizer
extends AnimatedSprite2D

## Node for handling an Entity's appearance.

# Linked Nodes
var entity: Entity

func _ready() -> void:
	GameManager.state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(new_state) -> void:
	match new_state:
		GameManager.GameState.PAUSED:
			speed_scale = 0.0
		_:
			speed_scale = 1.0

func update_animation(entity_context: Dictionary) -> void:
	var velocity = entity_context.get("velocity", 0.0)
	var grounded = entity_context.get("is_on_floor", true)
	var was_grounded = entity_context.get("was_on_floor", true)

	# Interrupt standard behaviour if in talking state.
	if entity is EntityNPC and entity.current_state == EntityNPC.State.TALKING:
		return

	# Set sprite facing direction.
	if velocity.x != 0:
		flip_h = velocity.x > 0
	
	# Choose animation based on state
	if not grounded:
		play_animation("jump")
	elif abs(velocity.x) > 10:
		play_animation("walk")
	else:
		play_animation("idle")
	
	# Play squash effect if just landed
	if !was_grounded and grounded:
		squash()

# Animation Methods
func play_animation(key: StringName):
	if sprite_frames.has_animation(key):
		play(key)

func face_direction(target_position: Vector2):
	var parent_pos = get_parent().global_position
	flip_h = parent_pos < target_position

# Effect Methods
func squish(strength = 1.0):
	scale.x = 0.6 / strength
	scale.y = 1.8 * strength
	
	_normalize_scale()

func squash(strength = 1.0):
	scale.x = 1.5 * strength
	scale.y = 0.6 / strength
	
	_normalize_scale()

func _normalize_scale():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
