extends StaticBody2D

@onready var pointer: Sprite2D = $Pointer
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 6

var bullet_scene = preload("res://Prefabs/Clotting/thrombokinase.tscn")

@export var selected = false

func _ready() -> void:
	animation.play("idle")
	
func _process(delta: float) -> void:
	pointer.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_select") and selected and !Trackers.mouse_on_platelet:
		fire()

	
func fire():
	var bullet = bullet_scene.instantiate()
	bullet.dir = pointer.rotation
	bullet.pos = pointer.global_position
	bullet.rota = pointer.global_rotation
	get_parent().add_child(bullet)

func select():
	selected = true
	pointer.show()
	animation.play("selected")

func unselect():
	selected = false
	pointer.hide()
	animation.play("idle")


func _on_button_mouse_entered() -> void:
	Trackers.mouse_on_platelet = true
	
func _on_button_mouse_exited() -> void:
	Trackers.mouse_on_platelet = false
