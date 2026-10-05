extends CanvasLayer
@onready var label: Label = $Panel/Label
@onready var interact: Button = $Interact
#@onready var meter: Label = $oxygen
@onready var back: PanelContainer = $Back

func _ready() -> void:
	back.hide()
	label.text = Trackers.current_location

func _process(delta: float) -> void:
	pass
	#meter.text = "Oxgygen: " + str(Trackers.oxygen)
func interaction_available(text: String):
	interact.show()
	interact.text = text
	
	
func interaction_unavailable():
	interact.hide()
	
func _on_button_pressed() -> void:
	if interact.text == "enter":
		get_tree().change_scene_to_file("res://Screens/tunnl_code.tscn")
