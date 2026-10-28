extends Node2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var dragging = false
var offset 
var untouched = true

var outside = true

func _ready() -> void:
	animation.play("particle_animation")

func _process(delta: float) -> void:
	rotation += 4 * delta
	if untouched:
		position.x -= 250 * delta
	if dragging and outside:
		position = get_global_mouse_position() - offset

func _on_button_button_down() -> void:
	untouched = false
	dragging = true
	offset = get_global_mouse_position() - position 

func _on_button_button_up() -> void:
	dragging = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bloodstream"):
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.2)
		var tweenb = create_tween()
		tweenb.tween_property(self, "scale", Vector2(0.3, 0.3), 0.2)
		await get_tree().create_timer(0.5).timeout
		Trackers.update_score(10)
		queue_free()
