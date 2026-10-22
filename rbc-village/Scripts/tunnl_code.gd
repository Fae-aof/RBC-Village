extends CanvasLayer

@onready var options_res = preload("res://Resources/Tunnel Code/option_list.tres")
@onready var grid: GridContainer = $MarginContainer/PanelContainer/Grid

var inputs = []
var current_input = 0
var answer_key = {"To Right Atrium" : ["Bone Marrow", "vena cava", "right atrium"],
				  "To Lungs" : ["Right Atrium", "tricuspid", "right ventricle", "pulmonary artery"],
				  "To Body Parts" : ["Lungs", "pulmonary vein", "left atrium", "bicuspid", "left ventricle", "aorta"]}

func _ready() -> void:
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
	var input_instance = get_node("InputedCode")
	var location_node = input_instance.get_node("StartingLocation")
	location_node.text = Trackers.current_location

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if current_input < 5:
		var part = get_viewport().gui_get_focus_owner()
		var resource = part.get_meta("resource")
		var selectedInput = "Input" + str(current_input)
		var input_instance = get_node("InputedCode")
		var sprite_node = input_instance.get_node("HBoxContainer").get_node(selectedInput).get_node("Sprite")
		var label_node = input_instance.get_node("HBoxContainer").get_node(selectedInput).get_node("Label")
		sprite_node.texture = resource.texture
		label_node.text = resource.name
		inputs.append(resource.name)
		current_input += 1
		
		print(inputs)


func _on_confirm_pressed() -> void:
	inputs.push_front(Trackers.current_location)
	print(inputs)
	if inputs == answer_key["To Right Atrium"]:
		Trackers.finish_quest(load("res://Resources/Quest/Right Atrium Quest.tres"))
		get_tree().change_scene_to_file("res://Sections/Right Atrium.tscn")
	if inputs == answer_key["To Lungs"]:
		get_tree().change_scene_to_file("res://Screens/Oxygen Test.tscn")
	if inputs == answer_key["To Body Parts"]:
		get_tree().change_scene_to_file("res://Capillaries.tscn")
	#else:
		#get_node("Response").text = "Invalid code inputted."
	inputs.remove_at(0)


func _on_back_pressed() -> void:
	print("checking")
	if current_input > 0:
		print("works")
		inputs.remove_at(-1)
		var selectedInput = "Input" + str(current_input - 1)
		var input_instance = get_node("InputedCode")
		var sprite_node = input_instance.get_node("HBoxContainer").get_node(selectedInput).get_node("Sprite")
		var label_node = input_instance.get_node("HBoxContainer").get_node(selectedInput).get_node("Label")
		sprite_node.texture = null
		label_node.text = ""
		current_input -= 1
		print(str(current_input) + " is the current box and code is " + str(inputs))
