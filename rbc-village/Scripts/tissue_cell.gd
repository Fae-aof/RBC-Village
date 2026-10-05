extends Area2D

@onready var healthy_sprite = preload("res://Milestone1_Sprites/milestone1_icons/icon_pulmonary_artery.jpeg")
@onready var unhealthy_sprite = preload("res://Milestone1_Sprites/milestone1_icons/icon_pulmonary_vein.jpeg")
@onready var need_food_sprite = preload("res://Milestone1_Sprites/milestone1_icons/icon_right_atrium.jpeg")
@onready var sprite: AnimatedSprite2D = $Sprite2D

@onready var waste_particle = preload("res://Prefabs/waste_particle.tscn")

var healthy = true
var need_food = false
var number = randi_range(0,3)

#func _ready() -> void:
	#var randomiser = randi_range(0, 10)
	#sprite.animation = "Good"
	#sprite.frame = number
	#if randomiser > 8:
		#healthy = false
		#set_sprite("Need_oxygen")
	#if randomiser == 5:
		#need_food = true
		#set_sprite("Need_food")
		#var particle = waste_particle.instantiate()
		#particle.position = Vector2(0, 0)
		#add_child(particle)
		
func on_creation(type: int):
	sprite.animation = "Good"
	sprite.frame = number
	if type == 1:
		healthy = false
		set_sprite("Need_oxygen")
	if type == 2:
		need_food = true
		set_sprite("Need_food")
		var particle = waste_particle.instantiate()
		particle.position = Vector2(0, 0)
		add_child(particle)


func _process(delta: float) -> void:
	position.x -= 250 * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("oxygen_particle") and !healthy:
		set_sprite("Good")
		healthy = true
		area.queue_free()
	if area.is_in_group("food_particle") and need_food:
		set_sprite("Good")
		healthy = true
		area.queue_free()

func set_sprite(state: String):
	sprite.animation = state
	sprite.frame = number
