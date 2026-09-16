extends Node2D
@onready var background: Parallax2D = $Parallax2D

var particle_scene = preload("res://Prefabs/oxygen_particle.tscn")
var timer = 0
var game_ongoing = true
var scroll_speed = Vector2(-500,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	background.autoscroll = scroll_speed
	if timer >= 0.6 and game_ongoing:
		create_particle()
		timer = 0
	if Trackers.oxygen >= 100:
		slow_down()
		game_ongoing = false
		
		

func create_particle():
	var particle = particle_scene.instantiate()
	particle.position = Vector2(randi() % 1280 + 500, 0)
	add_child(particle)

func slow_down():
	var tween = create_tween()
	tween.tween_property(self, "scroll_speed", Vector2.ZERO, 1)
