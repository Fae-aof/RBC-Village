extends Node
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	Trackers.connect("oxygen_update", update_bar)
	progress_bar.value = Trackers.oxygen

func update_bar():
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", Trackers.oxygen, 0.8)
