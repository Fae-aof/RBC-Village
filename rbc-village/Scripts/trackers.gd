extends Node2D

@onready var location_label: Label = UI.get_node('Panel').get_node("Label")

var current_location = "Bone Marrow"
var xp = 0
var oxygen = 0
var dialogue_active = false

#clotting stuff
var current_platelet
var fibrin_counter = 0
var mouse_on_platelet = false

var list = preload("res://Resources/Quest/Level1_QuestList.tres")

var ongoing_quests = []
var finished_quests = []
			
func update_location(new_location):
	current_location = new_location
	location_label.text = new_location
	

func add_quest(quest):
	if quest.status == "incomplete":
		quest.status = "ongoing"
		ongoing_quests.append(quest)
		UI.update_quest()
		
	
func finish_quest(quest):
	if quest.status == "ongoing":
		quest.status = "complete"
		ongoing_quests.erase(quest)
		finished_quests.append(quest)
		xp += quest.reward
		UI.update_quest()
