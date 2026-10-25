extends Node2D
#bg animation
@onready var animation: AnimatedSprite2D = $RoomBackground/AnimatedSprite2D

@export var location: String

func _ready() -> void:
	Trackers.update_location(location)


func _on_area_2d_area_exited(area: Area2D) -> void:
	UI.get_node("Interact").hide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	UI.get_node("Interact").show()
