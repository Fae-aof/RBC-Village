extends Node2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var speed_y = randi() % 200+50
var speed_x = randi() % 380 + 300
func _ready() -> void:
		animation.play("particle_animation")
	
func _process(delta):
	# Move right: Add to X position over time
	position.x -= speed_x * delta
	position.y += speed_y * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_whole"):
		Trackers.oxygen = min(Trackers.oxygen + 10, 100)
		queue_free()
	if area.is_in_group("despawn"):
		queue_free()
