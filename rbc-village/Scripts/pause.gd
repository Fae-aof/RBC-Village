extends Node

@onready var pause: Button = $Pause
@onready var pause_panel: Panel = $"Pause Panel"

func _on_pause_pressed() -> void:
	pause_panel.show()
	get_tree().paused = true


func _on_resume_pressed() -> void:
	pause_panel.hide()
	get_tree().paused = false
