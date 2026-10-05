extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var particle_scene = preload("res://Prefabs/oxygen_particle.tscn")
@export var speed: float = 300.0

var timer: float
var level_done = false
var oxy_spawn = 50

func _ready() -> void:
	animation.play("floating")
	Trackers.oxygen = 100
	
func _process(delta: float) -> void:
	if level_done == true:
		var tween = create_tween()
		tween.tween_property(self, "position", Vector2(1200, 0) + self.position, 2)
	timer += delta
	if timer > 1.3 and Trackers.oxygen > 0:
		spawn_oxygen()
		Trackers.oxygen -= 5
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
