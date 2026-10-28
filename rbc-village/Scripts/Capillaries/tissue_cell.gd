extends Area2D

@onready var healthy_sprite = preload("res://Milestone1_Sprites/milestone1_icons/icon_pulmonary_artery.jpeg")
@onready var unhealthy_sprite = preload("res://Milestone1_Sprites/milestone1_icons/icon_pulmonary_vein.jpeg")
@onready var need_food_sprite = preload("res://Milestone1_Sprites/milestone1_icons/icon_right_atrium.jpeg")
@onready var sprite: AnimatedSprite2D = $Sprite2D

@onready var waste_particle = preload("res://Prefabs/Capillaries/waste_particle.tscn")

var healthy = true
var need_food = false
var number = randi_range(0,3)

var speed = -250

func _ready() -> void:
	Trackers.connect("oxygen_depleted", level_done)

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
		get_parent().add_child(particle)


func _process(delta: float) -> void:
	position.x += speed * delta

func _on_area_entered(area: Area2D) -> void:
	var pop_time = 0.15
	if area.is_in_group("oxygen_particle") and !healthy:
		set_sprite("Good")
		healthy = true
		Trackers.update_score(5)
		area.queue_free()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), pop_time)
		await get_tree().create_timer(pop_time).timeout
		tween.kill()
		tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), pop_time)
	elif area.is_in_group("food_particle") and need_food:
		set_sprite("Good")
		healthy = true
		Trackers.update_score(10)
		area.queue_free()
		var tween = create_tween()
		tween.tween_property(self, "scale",Vector2(1.1, 1.1), pop_time)
		await get_tree().create_timer(pop_time).timeout
		tween.kill()
		tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1) , pop_time)

func set_sprite(state: String):
	sprite.animation = state
	sprite.frame = number

func level_done():
	pass
