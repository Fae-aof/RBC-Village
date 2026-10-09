extends RigidBody2D

var state = "prothrombin"
var thrombokinase_here = false
var thrombokinase = []
var fibronogen = []
var calcium_here = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var thrombin_sprite = preload("res://Milestone 3 Sprites/Clotting/IMG_1537.PNG")

func _process(delta: float) -> void:
	if calcium_here:
		if thrombokinase != [] and state == "prothrombin":
			print(thrombokinase)
			sprite.texture = thrombin_sprite
			state = "thrombin"
			for i in fibronogen:
				print("enable link")
				i.enable_link()
			fibronogen = []
			thrombokinase.pop_front().queue_free()

func _on_radius_body_entered(body: Node2D) -> void:
	if state == "prothrombin":
		if body.is_in_group("thrombokinase"):
			thrombokinase_here = true
			thrombokinase.append(body)
		if body.is_in_group("fibronogen"):
			fibronogen.append(body)
			print(fibronogen)
	else:
		if body.is_in_group("fibronogen"):
			print("enabling")
			body.enable_link()

func _on_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("thrombokinase"):
		thrombokinase_here = false
		thrombokinase.erase(body)
	if body.is_in_group("fibronogen"):
		fibronogen.erase(body)
