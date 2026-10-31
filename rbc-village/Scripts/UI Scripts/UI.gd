extends CanvasLayer

@onready var enter: Button = $Interact
var enter_bob_tween
@onready var possess: Button = $Possess

@onready var quest_ui: Control = $"Quest UI"
@onready var oxygen_bar: Node = $"Oxygen Bar"
@onready var xp_text: Label = $XP
@onready var location: Label = $Location
@onready var guide: Control = $Guide
@onready var quest_notif: Label = $"Quest Notification"

@onready var possess_sprite = preload("res://Milestone 3 Sprites/UI/possess icon.png")
@onready var enter_sprite = preload("res://Milestone 3 Sprites/UI/enter icon.png")

@onready var black_fade: ColorRect = $BlackFade
var fade_dur = 0.8

var button_function = null

signal possess_npc

var xp = 0

func _ready() -> void:
	location.text = Trackers.current_location

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	xp_text.text = "XP: " + str(xp)
	#meter.text = "Oxgygen: " + str(Trackers.oxygen)
	
func _on_button_pressed() -> void:
	fade_to_black("res://Screens/tunnl_code.tscn")

func enter_bobbing():
	enter.show()
	enter_bob_tween = create_tween().set_loops() 
	enter_bob_tween.tween_property(enter, "scale", Vector2(0.92, 0.92), 0.45)
	enter_bob_tween.tween_property(enter, "scale", Vector2(0.8, 0.8), 0.45)

func enter_hide():
	enter_bob_tween.kill()
	enter.scale = Vector2(0.84, 0.84)
	enter.hide()
	
func update_quest():
	quest_ui.update_questlist()
	
func quest_alert(adding : bool, name : String):
	if adding: 
		quest_notif.text = '"' + name + '" Added'
		quest_notif.show()
		var tween = create_tween()
		tween.tween_property(quest_notif, "scale", Vector2(1, 1), 0.3)
		tween.tween_property(quest_notif, "modulate:a", 0.0, 1)
		await get_tree().create_timer(1.4).timeout
		quest_notif.modulate.a = 1.0
		quest_notif.scale = Vector2(0.65, 0.65)
		quest_notif.hide()
	else:
		quest_notif.text = '"' + name + '" Completed!'
		quest_notif.show()
		var tween = create_tween()
		tween.tween_property(quest_notif, "scale", Vector2(1, 1), 0.3)
		tween.tween_property(quest_notif, "modulate:a", 0.0, 1)
		await get_tree().create_timer(1.4).timeout
		quest_notif.scale = Vector2(0.65, 0.65)
		quest_notif.modulate.a = 1.0
		quest_notif.hide()

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
		xp_text.show()
	else:
		xp_text.hide()

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

func update_xp(new_xp : int):
	var new_xp_total = new_xp + xp
	var tween = create_tween()
	tween.tween_method(set_xp_text, xp, new_xp_total, 0.3)
	xp = new_xp_total
	
func set_xp_text(value: int):
	xp_text.text = "XP: " + str(value)
