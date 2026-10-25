extends Node2D

var tissue_scene = preload("res://Prefabs/Capillaries/tissue_cell.tscn")
var timer = 0

var list = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2]
var step = 0
func _ready() -> void:
	list.shuffle()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 0.7:
		var tissue_cell = tissue_scene.instantiate()
		tissue_cell.position = Vector2(0, 0)
		add_child(tissue_cell)
		tissue_cell.on_creation(list[step])
		timer = 0
		step += 1
		if step > 8:
			step = 0
			list.shuffle()
