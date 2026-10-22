extends CanvasLayer
@onready var label: Label = $Panel/Label
@onready var interact: Button = $Interact
#@onready var meter: Label = $oxygen
@onready var back: PanelContainer = $Back

@onready var quest_ui: Control = $"Quest UI"
@onready var oxygen_bar: Node = $"Oxygen Bar"
@onready var xp: Label = $XP

func _ready() -> void:
	label.text = Trackers.current_location

func _process(delta: float) -> void:
	xp.text = "XP: " + str(Trackers.xp)
	#meter.text = "Oxgygen: " + str(Trackers.oxygen)
func interaction_available(text: String):
	interact.show()
	interact.text = text
	
func interaction_unavailable():
	interact.hide()
	
func _on_button_pressed() -> void:
	if interact.text == "enter":
		get_tree().change_scene_to_file("res://Screens/tunnl_code.tscn")

func update_quest():
	quest_ui.update_questlist()

func toggle_quest(toggle : bool):
	if toggle:
		quest_ui.show()
	else:
		quest_ui.hide()
	
func toggle_oxygen(toggle : bool):
	if toggle:
		oxygen_bar.show()
		print("show bar")
	else:
		oxygen_bar.hide()
		print("hide bar")
