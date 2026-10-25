extends Node2D

@onready var background: Parallax2D = $Parallax2D
@onready var score_label: Label = $Score
@onready var cell_spawner: Node2D = $"cell spawner"
@onready var cell_spawner_2: Node2D = $"cell spawner2"

var scroll_speed = Vector2(-250,0)
var score = 0

func _ready() -> void:
	Trackers.connect("score_update", update_score)


func _process(delta: float) -> void:
	background.autoscroll = scroll_speed


func update_score():
	var tween = create_tween()
	tween.tween_method(set_score_text, score, Trackers.score, 0.3)
	score = Trackers.score
	
func set_score_text(value: int):
	score_label.text = "Score: " + str(value)

func slow_down():
	var tween = create_tween()
	tween.tween_property(self, "scroll_speed", Vector2.ZERO, 1)
