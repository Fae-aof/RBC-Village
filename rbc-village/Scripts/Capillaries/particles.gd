extends Node2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var dragging = false
var offset 

func _ready() -> void:
	animation.play("particle_animation")

func _process(delta: float) -> void:
	rotation += 4 * delta
	if dragging:
		position = get_global_mouse_position() - offset

func _on_button_button_down() -> void:
	dragging = true
	offset = get_global_mouse_position() - position 


func _on_button_button_up() -> void:
	dragging = false


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("bloodstream"):
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.2)
		var tweenb = create_tween()
		tweenb.tween_property(self, "scale", Vector2(0.3, 0.3), 0.2)
		await get_tree().create_timer(0.5).timeout
		queue_free()
