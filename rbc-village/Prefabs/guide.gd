extends Control

@onready var guide_button: Button = $"Guide Button"
@onready var guide_panel: NinePatchRect = $"Guide Panel"
@onready var cancel_button: Button = $"Cancel Button"


func _on_guide_button_pressed() -> void:
	guide_button.hide()
	guide_panel.show()
	cancel_button.show()

func _on_cancel_button_pressed() -> void:
	guide_button.show()
	guide_panel.hide()
	cancel_button.hide()
