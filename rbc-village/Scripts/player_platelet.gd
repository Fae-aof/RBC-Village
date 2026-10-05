extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 6

var bullet_scene = preload("res://Prefabs/Clotting/thrombokinase.tscn")

func _ready() -> void:
	animation.play("floating")
	
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_accept"):
		print("fire")
		fire()

	
func fire():
	var bullet = bullet_scene.instantiate()
	bullet.dir = rotation
	bullet.pos = global_position
	bullet.rota = global_rotation
	get_parent().add_child(bullet)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	global_position += input_direction * speed
	
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false

	if Trackers.oxygen >= 100 and animation.animation != "oxygenated":
		animation.play("oxygenated")

func _physics_process(_delta):
	get_input()
	move_and_slide()
