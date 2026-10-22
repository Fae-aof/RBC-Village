extends Node

@export var oxygen_bar_on = true
@export var quest_icon_on = true

func _ready() -> void:
	if oxygen_bar_on:
		UI.toggle_oxygen(true)
	else:
		UI.toggle_oxygen(false)
		
	if quest_icon_on:
		UI.toggle_quest(true)
	else:
		UI.toggle_quest(false)
