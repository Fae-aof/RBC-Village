extends Node2D

@onready var Back: PanelContainer = UI.get_node('Back')
@onready var location_label: Label = UI.get_node('Panel').get_node("Label")
@onready var label: Label = UI.get_node("Back").get_node("VBoxContainer").get_node("Label")

var current_location = "Bone Marrow"
var oxygen = 0
var dialogue_active = false
var quest_list = []

var location = ""
var quest_dict = {
	"Go to Right Atrium": [0, "incomplete"],
	"Get oxygen in Lungs": [100, "incomplete"],
	"Transfer oxygen to Leg": [200, "incomplete"]
}
var current_quests =[]

func update_location(new_location):
	location = new_location
	location_label.text = new_location

func add_quest(quest):
	if quest_dict[quest][1] == "incomplete":
		current_quests.append(quest)
		Back.show()
		label.text = current_quests[0]
		quest_dict[quest][1] = "complete"
	
func finish_quest(quest):
	if current_quests.has(quest):
		current_quests.erase(quest)
		oxygen += quest_dict[quest][0]
		Back.hide()
