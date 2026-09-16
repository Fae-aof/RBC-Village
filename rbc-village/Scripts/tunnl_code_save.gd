extends Node2D
@onready var border: AnimatedSprite2D = $Border
@onready var grid: GridContainer = $CanvasLayer/PanelContainer/MarginContainer/GridContainer

var inputs = []
var current_input = 0
var answer_key = {"To Right Atrium" : ["bone_marrow", "vena_cava", "right_atrium"],
				  "To Lungs" : ["right_atrium", "tricuspid", "right_ventricle", "pulmonary_artery"],
				  "To Body Parts" : ["lungs", "pulmonary_vein", "left_atrium", "bicuspid", "left_ventricle", "aorta"]}

func _ready() -> void:
	border.play("border")
	print(grid.get_children())
	var options = ["aorta", "bicuspid", "tricuspid", "vena_cava", "pulmonary_artery", "pulmonary_vein", 
	"left_ventricle", "left_atrium", "right_atrium", "right_ventricle"]
	options.shuffle()
	var selectedNumber = 0
	for i in options:
		var selected = str(selectedNumber)
		var selectedButton = "Button" + selected
		
		var sprite_path = "res://Milestone1_Sprites/milestone1_icons/icon_" + options[selectedNumber] + ".jpeg"
		
		var button_instance = get_node(selectedButton)
		var button_node = button_instance.get_node("Button")
		var icon_node = button_instance.get_node("Icon")
		
		icon_node.texture = load(sprite_path)
		button_node.text = options[selectedNumber]
		selectedNumber += 1
		print(selectedNumber)
	
	# Setting Start Location
	var input_instance = get_node("InputedCode")
	var location_node = input_instance.get_node("StartingLocation")
	location_node.text = Trackers.current_location

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if current_input < 6:
		var part = get_viewport().gui_get_focus_owner()
		var input_name = part.text
		var selectedInput = "Input" + str(current_input)
		var sprite_path = "res://Milestone1_Sprites/milestone1_icons/icon_" + input_name + ".jpeg"
		
		var input_instance = get_node("InputedCode")
		var input_node = input_instance.get_node(selectedInput)
		
		input_node.texture = load(sprite_path)
		
		inputs.append(input_name)
		current_input += 1
		
		print(inputs)


func _on_back_pressed() -> void:
	if current_input > 0:
		inputs.remove_at(-1)
		var selectedInput = "Input" + str(current_input - 1)
		var input_instance = get_node("InputedCode")
		var input_node = input_instance.get_node(selectedInput)
		input_node.texture = load("res://Milestone1_Sprites/milestone1_icons/icon_blank.jpeg")
		current_input -= 1
		print(str(current_input) + " is the current box and code is " + str(inputs))


func _on_confirm_pressed() -> void:
	inputs.push_front(Trackers.current_location)
	if inputs == answer_key["To Right Atrium"]:
		get_tree().change_scene_to_file("res://Locations/Right Atrium.tscn")
	if inputs == answer_key["To Lungs"]:
		get_tree().change_scene_to_file("res://Locations/Lung.tscn")
	else:
		get_node("Response").text = "Invalid code inputted."
	inputs.remove_at(0)
