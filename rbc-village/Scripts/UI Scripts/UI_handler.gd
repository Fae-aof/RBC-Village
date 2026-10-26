extends Node

@export var oxygen_bar_on = true
@export var quest_icon_on = true
@export var xp_on = true
@export var guide_on = true

func _ready() -> void:
	UI.toggle_oxygen(oxygen_bar_on)
	UI.toggle_quest(quest_icon_on)
	UI.toggle_xp(xp_on)
	UI.toggle_guide(guide_on)
