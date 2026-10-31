extends Node2D

@onready var prothrombin_scene = preload("res://Prefabs/Clotting/prothrombin.tscn")
@onready var fibronogen_scene = preload("res://Prefabs/Clotting/fibronogen.tscn")
@onready var calcium_scene = preload("res://Prefabs/Clotting/calcium.tscn")
@onready var platelets: Node2D = $Platelets
@onready var cam: Camera2D = $Camera2D
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var calcium_parent: Node2D = $"Calcium Parent"

var timerA = 0
var timerB = 0
var spawnpoint
var step = 100

var platelet_array

func _ready() -> void:
	for x in range(-685, 2240, step):
		for y in range(-220, 948, step):
			spawnpoint = Vector2(x + randf_range(step/5, 4*step/5), y + randf_range(step/5, 4*step/5))
			var fibronogen = fibronogen_scene.instantiate()
			fibronogen.global_position = spawnpoint
			fibronogen.rotation = randf_range(0, 360)
			add_child(fibronogen)
	#for x in range(-1428, 727, 715):
		#for y in range(-515, 335, 275):
			#spawnpoint = Vector2(x + randf_range(step/5, 4*step/5), y + randf_range(step/5, 4*step/5))
			#print(spawnpoint)
			#var calcium = calcium_scene.instantiate()
			#calcium.global_position = spawnpoint
			#calcium_parent.add_child(calcium)
	
	platelet_array = platelets.get_children()
	for i in platelet_array:
		var button = i.get_node("Button")
		button.connect("pressed", select_platelet)
		if i.selected == true:
			cam.global_position = i.global_position
			i.select()
	
func select_platelet():
	var button = get_viewport().gui_get_focus_owner()
	var platelet = button.get_parent()
	var half_view = get_viewport_rect().size / (2 * cam.zoom)
	var target_position = platelet.global_position
	target_position.x = clampf(target_position.x, cam.limit_left + half_view.x, cam.limit_right - half_view.x)
	target_position.y = clampf(target_position.y, cam.limit_left + half_view.y, cam.limit_right - half_view.y)
	var tween = create_tween()
	tween.tween_property(cam, "global_position", target_position, 0.25)
	for i in platelet_array:
		i.unselect()
	platelet.select()


func _process(delta: float) -> void:
	progress_bar.value = Trackers.fibrin_counter
	timerA += delta
	timerB += delta
	if timerA >= 1:
		for i in 10:
			var fibronogen = fibronogen_scene.instantiate()
			fibronogen.position = Vector2(randf_range(-685, 2240), randf_range(-220, 948))
			add_child(fibronogen)
		timerA = 0
	if timerB >= 3:
		var prothrombin = prothrombin_scene.instantiate()
		prothrombin.position = Vector2(randf_range(-320, 1900), randf_range(50, 778))
		add_child(prothrombin)
		timerB = 0
