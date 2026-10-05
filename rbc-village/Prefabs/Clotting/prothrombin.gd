extends RigidBody2D

var state = "prothrombin"

@onready var sprite: Sprite2D = $Sprite2D
@onready var thrombin_sprite = preload("res://Milestone 3 Sprites/Clotting/IMG_1537.PNG")

func convert():
	sprite.texture = thrombin_sprite
	
	state = "thrombin"
