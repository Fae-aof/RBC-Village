extends CanvasLayer

@onready var options_res = preload("res://Resources/Tunnel Code/option_list.tres")
@onready var grid: GridContainer = $MarginContainer/PanelContainer/Grid
@onready var starting_location: Label = $"Starting Location"
@onready var h_box: HBoxContainer = $InputHbox
@onready var panel: Panel = $Panel

@onready var normal_stylebox = preload("res://Styleboxes/Input box white.tres")
@onready var green_stylebox = preload("res://Styleboxes/Input box green.tres")
@onready var red_stylebox = preload("res://Styleboxes/Input box red.tres")
@onready var input_0: Panel = $InputHbox/Input0

var inputs = []
var current_input = 0
var answer_key = {"To Right Atrium" : ["Bone Marrow", "vena cava", "right atrium"],
				  "To Lungs" : ["Right Atrium", "tricuspid", "right ventricle", "pulmonary artery"],
				  "To Body Parts" : ["Lungs", "pulmonary vein", "left atrium", "bicuspid", "left ventricle", "aorta"]}

var input_nodes = []

func _ready() -> void:
	input_nodes = h_box.get_children()
	var options = options_res.list
	var button_list = grid.get_children()
	for button in button_list:
		button.connect("pressed", _on_button_pressed)
	options.shuffle()
	var selectedNumber = 0
	for i in options:
		var current_button = button_list[selectedNumber]
		var icon_node = current_button.get_node("Icon")
		var label_node = current_button.get_node("Label")
		icon_node.texture = i.texture
		label_node.text = i.name
		current_button.set_meta("resource", i)

		selectedNumber += 1
	
	# Setting Start Location
	
	starting_location.text = "Now Leaving: " + Trackers.current_location

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if current_input < 5:
		var part = get_viewport().gui_get_focus_owner()
		var resource = part.get_meta("resource")
		var sprite_node = input_nodes[current_input].get_node("Sprite")
		var label_node = input_nodes[current_input].get_node("Label")
		sprite_node.texture = resource.texture
		sprite_node.scale = Vector2(0.3,0.3)
		var tween = create_tween()
		tween.tween_property(sprite_node, "scale", Vector2(0.562, 0.562), 0.2)
		label_node.text = resource.name
		inputs.append(resource.name)
		current_input += 1
		
		print(inputs)


func _on_confirm_pressed() -> void:
	inputs.push_front(Trackers.current_location)
	print(inputs)
	if inputs == answer_key["To Right Atrium"]:
		await green_light()
		await get_tree().create_timer(0.4).timeout
		Trackers.finish_quest(load("res://Resources/Quest/Right Atrium Quest.tres"))
		get_tree().change_scene_to_file("res://Sections/Right Atrium.tscn")
	if inputs == answer_key["To Lungs"]:
		get_tree().change_scene_to_file("res://Screens/Oxygen Test.tscn")
	if inputs == answer_key["To Body Parts"]:
		get_tree().change_scene_to_file("res://Capillaries.tscn")
	else:
		for i in input_nodes:
			var label_node = i.get_node("Label")
			if label_node.text != "": 
				i.add_theme_stylebox_override("panel", red_stylebox)
		await get_tree().create_timer(0.5).timeout
		for i in input_nodes:
			i.add_theme_stylebox_override("panel", normal_stylebox)
	inputs.remove_at(0)

func green_light():
	for i in input_nodes:
		print(i)
		var label_node = i.get_node("Label")
		if label_node.text != "":
			print('not empty')
			i.add_theme_stylebox_override("panel", green_stylebox)
			await get_tree().create_timer(0.25).timeout
			
func _on_back_pressed() -> void:
	print("checking")
	if current_input > 0:
		print("works")
		inputs.remove_at(-1)
		current_input -= 1
		var sprite_node = input_nodes[current_input].get_node("Sprite")
		var label_node = input_nodes[current_input].get_node("Label")
		var tween = create_tween()
		tween.tween_property(sprite_node, "scale", Vector2(0.2, 0.2), 0.1)
		await get_tree().create_timer(0.1).timeout
		sprite_node.texture = null
		sprite_node.scale = Vector2(0.562, 0.562)
		label_node.text = ""
		print(str(current_input) + " is the current box and code is " + str(inputs))
