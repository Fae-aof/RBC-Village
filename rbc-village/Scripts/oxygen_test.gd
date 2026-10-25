extends CanvasLayer

@onready var qn_text: Label = $MarginContainer/Panel/Label
@onready var grid: GridContainer = $MarginContainer/GridContainer

@onready var correct_stylebox = preload("res://Styleboxes/quiz correct.tres")
@onready var incorrect_stylebox = preload("res://Styleboxes/quiz incorrect.tres")
@onready var normal_stylebox = preload("res://Styleboxes/quiz blocks.tres")
@onready var next_question: Button = $"Next Question"


var question_list = [preload("res://Resources/Question/Question1.tres"), preload("res://Resources/Question/Question2.tres"), preload("res://Resources/Question/Question3.tres"), preload("res://Resources/Question/Question4.tres")]

var question_number = 0
var answer_list 
var answer_buttons
var qn
var answer

var key_number
var correct_button
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
			i.connect("pressed", _on_incorrect_pressed.bind(i))
			answer_no += 1
		key_number = answer_list.find(answer)
		correct_button = answer_buttons[key_number]
		correct_button.disconnect("pressed", _on_incorrect_pressed)
		correct_button.connect("pressed", _on_correct_pressed.bind(correct_button))
		question_number += 1

func _on_incorrect_pressed(button: Button) -> void:
	button.add_theme_stylebox_override("normal", incorrect_stylebox)
	button.add_theme_stylebox_override("disabled", incorrect_stylebox)
	correct_button.add_theme_stylebox_override("normal", correct_stylebox)
	correct_button.add_theme_stylebox_override("disabled", correct_stylebox)
	next_question.show()
	for i in answer_buttons:
		i.disabled = true
	await get_tree().create_timer(0.7).timeout
	
func _on_correct_pressed(button: Button) -> void:
	button.add_theme_stylebox_override("normal", correct_stylebox)
	button.add_theme_stylebox_override("disabled", correct_stylebox)
	next_question.show()
	Trackers.update_oxygen(25)
	for i in answer_buttons:
		i.disabled = true
	await get_tree().create_timer(0.7).timeout


func _on_next_question_pressed() -> void:
	for i in answer_buttons:
		i.disabled = false
		i.add_theme_stylebox_override("normal", normal_stylebox)
		i.add_theme_stylebox_override("disabled", normal_stylebox)
	new_question()
	next_question.hide()
