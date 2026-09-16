extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 300.0
var timer = 0
var level_done = false
func _ready() -> void:
	animation.play("floating")
	
func _process(delta: float) -> void:
	if Trackers.oxygen >= 100 and level_done == false:
		var tween = create_tween()
		tween.tween_property(self, "position", Vector2(1200, 0) + self.position, 2)
		level_done = true
		timer = 0
	timer += delta
	if level_done and timer > 2:
		get_tree().change_scene_to_file("res://Locations/Left Atrium.tscn")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction.x = 0
	velocity = input_direction * speed * 1.2
	
	
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false

	if Trackers.oxygen >= 100 and animation.animation != "oxygenated":
		animation.play("oxygenated")

func _physics_process(_delta):
	get_input()
	move_and_slide()
