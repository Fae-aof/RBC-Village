extends Control

@onready var quest_button: Button = $"Quest Button"
@onready var cancel_button: Button = $"Cancel Button"
@onready var quest_panel: NinePatchRect = $"Quest Panel"
@onready var v_box: VBoxContainer = $"Quest Panel/MarginContainer/VBoxContainer"
@onready var ongoing: Label = $"Quest Panel/MarginContainer/VBoxContainer/Ongoing"
@onready var finished: Label = $"Quest Panel/MarginContainer/VBoxContainer/Finished"
@onready var alert: Sprite2D = $Alert

func _ready() -> void:
	update_questlist()

func update_questlist():
	if Trackers.ongoing_quests == []:
		ongoing.hide()
	else:
		var ongoing_array = []
		for i in Trackers.ongoing_quests:
			ongoing_array.append(i.name)
		var ongoing_text = "\n".join(ongoing_array)
		ongoing.text = ongoing_text
		ongoing.show()
		alert.show()
	if Trackers.finished_quests == []:
		finished.hide()
	else:
		var done_array = []
		for i in Trackers.finished_quests:
			done_array.append(i.name)
		var done_text = "\n".join(done_array)
		finished.text = done_text
		finished.show()

func _on_quest_button_pressed() -> void:
	alert.hide()
	quest_panel.show()
	cancel_button.show()
	quest_button.hide()

func _on_cancel_button_pressed() -> void:
	quest_panel.hide()
	cancel_button.hide()
	quest_button.show()
