extends Node2D

@onready var location_label: Label = UI.get_node('Location')

var current_location = "Bone Marrow"
var oxygen = 0
var dialogue_active = false

var score = 0

#clotting stuff
var current_platelet
var fibrin_counter = 0
var mouse_on_platelet = false

var list = preload("res://Resources/Quest/Level1_QuestList.tres")

var ongoing_quests = []
var finished_quests = []

signal oxygen_update
signal score_update
signal oxygen_depleted

func update_location(new_location):
	current_location = new_location
	location_label.text = new_location

func update_oxygen(added_oxygen: int):
	oxygen += added_oxygen
	oxygen = clamp(oxygen, 0, 100)
	if oxygen <= 0:
		emit_signal("oxygen_depleted")
	emit_signal("oxygen_update")

func update_score(added_score: int):
	score += added_score
	emit_signal("score_update")

func add_quest(quest):
	if quest.status == "incomplete":
		quest.status = "ongoing"
		ongoing_quests.append(quest)
		UI.update_quest()
		UI.quest_alert(true, quest.name)
		
	
func finish_quest(quest):
	if quest.status == "ongoing":
		quest.status = "complete"
		ongoing_quests.erase(quest)
		finished_quests.append(quest)
		UI.update_xp(quest.reward)
		UI.update_quest()
		UI.quest_alert(false, quest.name)
