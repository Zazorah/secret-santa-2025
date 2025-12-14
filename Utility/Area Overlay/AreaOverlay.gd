class_name AreaOverlay
extends CanvasLayer

const TEXTURE_LOOKUP := {
	"Crater County": preload("res://Utility/Area Overlay/Assets/CraterCounty.png")
}

@onready var sprite = $Sprite 

func _ready() -> void:
	if TEXTURE_LOOKUP.has(GameManager.current_area):
		sprite.texture = TEXTURE_LOOKUP[GameManager.current_area]
	
	await _do_entrance()
	await get_tree().create_timer(1.0).timeout
	await _do_exit()
	
	queue_free()

func _do_entrance() -> void:
	sprite.scale = Vector2(0.25, 0.25) * 0.25
	sprite.modulate.a = 0.0
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	
	var target_scale = Vector2(0.25, 0.25) * 1.0
	tween.tween_property(self, "sprite:scale", target_scale, 1.0)
	tween.tween_property(self, "sprite:modulate:a", 1.0, 1.0)
	
	await tween.finished

func _do_exit() -> void:
	sprite.scale = Vector2(0.25, 0.25) * 1.0
	sprite.modulate.a = 1.0
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	
	tween.tween_property(self, "sprite:scale", Vector2(0.25, 0.25) * 0.25, 1.0)
	tween.tween_property(self, "sprite:modulate:a", 0.0, 1.0)
	
	await tween.finished
