extends RigidBody2D

var state = "prothrombin"
var thrombokinase_here = false
var thrombokinase = []
var fibronogen = []
var calcium_here = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var thrombin_sprite = preload("res://Milestone 3 Sprites/better clotting sprites/thrombin.png")

var lifespan = randf_range(20, 30)
var timer = 0

func _process(delta: float) -> void:
	timer += delta
	if timer > lifespan:
		queue_free()
	if calcium_here:
		if thrombokinase != [] and state == "prothrombin":
			lifespan = randf_range(10, 15)
			sprite.texture = thrombin_sprite
			var tween = create_tween()
			tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.2)
			tween.tween_property(sprite, "scale", Vector2(0.85, 0.85), 0.3)
			state = "thrombin"
			for i in fibronogen:
				i.enable_link()
			fibronogen = []

func _on_radius_body_entered(body: Node2D) -> void:
	timer = 0
	if state == "prothrombin":
		if body.is_in_group("thrombokinase"):
			thrombokinase_here = true
			thrombokinase.append(body)
		if body.is_in_group("fibronogen"):
			fibronogen.append(body)
	else:
		if body.is_in_group("fibronogen"):
			body.enable_link()

func _on_radius_body_exited(body: Node2D) -> void:
	timer = 0
	if body.is_in_group("thrombokinase"):
		thrombokinase_here = false
		thrombokinase.erase(body)
	if body.is_in_group("fibronogen"):
		fibronogen.erase(body)
