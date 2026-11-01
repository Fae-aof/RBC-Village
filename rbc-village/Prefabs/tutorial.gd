extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true



func _on_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()
