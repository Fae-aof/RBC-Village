extends CanvasLayer

@onready var qn_text: Label = $MarginContainer/Panel/Label
@onready var grid: GridContainer = $MarginContainer/GridContainer

var question_list = [preload("res://Resources/Quest/Question1.tres"), preload("res://Resources/Quest/Question2.tres"), preload("res://Resources/Quest/Question3.tres"), preload("res://Resources/Quest/Question4.tres")]

var question_number = 0
var answer_list 
var answer_buttons
var qn
var answer

var key_number
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Trackers.current_location = "Lungs"
	question_list.shuffle()
	answer_buttons = grid.get_children()
	new_question()

func new_question():
	print(question_number)
	if question_number >= question_list.size():
		$MarginContainer.hide()
		get_tree().change_scene_to_file("res://Screens/tunnl_code.tscn")
	else:
		qn = question_list[question_number]
		qn_text.text = qn.question
		answer_list = qn.answers
		answer = answer_list[0]
		answer_list.shuffle()
		var answer_no = 0
		for i in answer_buttons:
			i.text = answer_list[answer_no]
			i.connect("pressed", _on_incorrect_pressed)
			answer_no += 1
		key_number = answer_list.find(answer)
		answer_buttons[key_number].disconnect("pressed", _on_incorrect_pressed)
		answer_buttons[key_number].connect("pressed", _on_correct_pressed)
		question_number += 1

func _on_incorrect_pressed() -> void:
	new_question()
	
func _on_correct_pressed() -> void:
	Trackers.oxygen += 25
	new_question()
