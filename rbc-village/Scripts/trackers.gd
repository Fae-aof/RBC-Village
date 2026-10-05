extends Node2D

@onready var Back: PanelContainer = UI.get_node('Back')
@onready var location_label: Label = UI.get_node('Panel').get_node("Label")
@onready var label: Label = UI.get_node("Back").get_node("VBoxContainer").get_node("Label")

var current_location = "Bone Marrow"
var oxygen = 0
var dialogue_active = false

var list = preload("res://Resources/Quest/Level1_QuestList.tres")
			
func update_location(new_location):
	current_location = new_location
	location_label.text = new_location
	

func add_quest(quest):
	if quest.status == "incomplete":
		quest.status = "ongoing"
		Back.show()
		label.text = quest.name
		
	
func finish_quest(quest):
	if quest.status == "ongoing":
		quest.status = "complete"
		Back.hide()
