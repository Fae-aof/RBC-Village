extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var particle_scene = preload("res://Prefabs/Capillaries/oxygen_particle.tscn")
@export var speed: float = 300.0

var timer: float
var oxy_spawn = 50

func _ready() -> void:
	animation.play("floating")
	Trackers.connect("oxygen_depleted", level_done)
	
func _process(delta: float) -> void:
	timer += delta
	if timer > 1.3 and Trackers.oxygen > 0:
		spawn_oxygen()
		Trackers.update_oxygen(-5)
		timer = 0
	if level_done and timer > 2:
		get_tree().change_scene_to_file("res://Locations/Left Atrium.tscn")

func spawn_oxygen():
	var x = randf_range(-oxy_spawn, oxy_spawn)
	var y = randf_range(-oxy_spawn, oxy_spawn)
	print(x)
	print(y)
	var particle = particle_scene.instantiate()
	particle.position = Vector2(x, y)
	add_child(particle)

func level_done():
	pass
	#var tween = create_tween()
	#tween.tween_property(self, "position", Vector2(1200, 0) + self.position, 2)
