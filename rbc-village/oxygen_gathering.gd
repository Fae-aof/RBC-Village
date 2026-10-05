extends Node2D
@onready var background: Parallax2D = $Parallax2D

var scroll_speed = Vector2(-250,0)
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	background.autoscroll = scroll_speed		
		

func slow_down():
	var tween = create_tween()
	tween.tween_property(self, "scroll_speed", Vector2.ZERO, 1)
