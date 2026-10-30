extends CanvasLayer

@onready var interact: Button = $Interact
@onready var possess: Button = $Possess

@onready var quest_ui: Control = $"Quest UI"
@onready var oxygen_bar: Node = $"Oxygen Bar"
@onready var xp: Label = $XP
@onready var location: Label = $Location
@onready var guide: Control = $Guide

@onready var possess_sprite = preload("res://Milestone 3 Sprites/UI/possess icon.png")
@onready var enter_sprite = preload("res://Milestone 3 Sprites/UI/enter icon.png")

@onready var black_fade: ColorRect = $BlackFade
var fade_dur = 0.8

var button_function = null

signal possess_npc

func _ready() -> void:
	location.text = Trackers.current_location
	
	

func _process(delta: float) -> void:
	xp.text = "XP: " + str(Trackers.xp)
	#meter.text = "Oxgygen: " + str(Trackers.oxygen)
	
func _on_button_pressed() -> void:
	fade_to_black("res://Screens/tunnl_code.tscn")


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
	else:
		oxygen_bar.hide()

func toggle_xp(toggle : bool):
	if toggle:
		xp.show()
	else:
		xp.hide()

func toggle_guide(toggle : bool):
	if toggle:
		guide.show()
	else:
		guide.hide()

func _on_possess_pressed() -> void:
	emit_signal("possess_npc")

func fade_to_black(scene : String):
	black_fade.show()
	var tween = create_tween()
	tween.tween_property(black_fade, "color:a", 1, fade_dur)
	await get_tree().create_timer(fade_dur).timeout
	get_tree().change_scene_to_file(scene)
	var tweenb = create_tween()
	tweenb.tween_property(black_fade, "color:a", 0.0, fade_dur)
	await get_tree().create_timer(fade_dur).timeout
	black_fade.hide()
