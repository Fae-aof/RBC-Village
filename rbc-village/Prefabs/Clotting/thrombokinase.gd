extends RigidBody2D

var pos: Vector2
var dir: float
var rota: float
var speed = 450
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	global_rotation = rota

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	linear_velocity = Vector2(speed, 0).rotated(dir)
	
