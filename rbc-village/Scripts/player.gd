extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 500.0

func _ready() -> void:
	animation.play("floating")
	
func _process(delta: float) -> void:
	if Trackers.dialogue_active == true:
		speed = 0
	else:
		speed = 300.0

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false

	if Trackers.oxygen >= 100 and animation.animation != "oxygenated":
		animation.play("oxygenated")

func _physics_process(_delta):
	get_input()
	move_and_slide()
