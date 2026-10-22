extends Node2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var dragging = false
var offset 
var untouched = true

func _ready() -> void:
	animation.play("particle_animation")

func _process(delta: float) -> void:
	rotation += 4 * delta
	if !untouched:
		position.x += 250 * delta
	if dragging:
		position = get_global_mouse_position() - offset

func _on_button_button_down() -> void:
	untouched = false
	dragging = true
	offset = get_global_mouse_position() - position 


func _on_button_button_up() -> void:
	dragging = false
