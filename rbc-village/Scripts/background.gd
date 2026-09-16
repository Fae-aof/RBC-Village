extends Node2D
#bg animation
@onready var animation: AnimatedSprite2D = $RoomBackground/AnimatedSprite2D

func _ready() -> void:
	var location = get_meta("location")
	Trackers.update_location(location)


func _on_area_2d_area_exited(area: Area2D) -> void:
	UI.interaction_unavailable()


func _on_area_2d_area_entered(area: Area2D) -> void:
	UI.interaction_available("enter")
