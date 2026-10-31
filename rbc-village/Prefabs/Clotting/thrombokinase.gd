extends RigidBody2D

var pos: Vector2
var dir: float
var rota: float
var speed = 600
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	global_rotation = rota

func _process(delta: float) -> void:
	timer += delta
	if timer > 4:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	linear_velocity = Vector2(speed, 0).rotated(dir)
	
