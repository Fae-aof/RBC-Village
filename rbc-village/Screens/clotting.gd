extends Node2D

@onready var fibronogen_scene = preload("res://Prefabs/Clotting/fibronogen.tscn")

var timer = 0
var spawnpoint
var step = 100

func _ready() -> void:
	for x in range(0, 1280, step):
		for y in range(0, 720, step):
			spawnpoint = Vector2(x + randf_range(step/5, 4*step/5), y + randf_range(step/5, 4*step/5))
			var fibronogen = fibronogen_scene.instantiate()
			fibronogen.global_position = spawnpoint
			fibronogen.rotation = randf_range(0, 360)
			add_child(fibronogen)
