extends Node2D

@onready var button: Button = $Button
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var letter: String 
@export var frame: int = 1
@onready var tap_to_chat: Label = $"Tap to Chat"
@onready var shadow: Sprite2D = $Shadow

var player_detected = false
@export var possessable = true
@export var task: Quest
var letter_list = ["A", "B", "C", "D"]

var tween_bobbing
var tween_shadow

@export var dialogue: DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play(letter)
	animation.pause()
	animation.frame = frame
	await get_tree().create_timer(randf_range(0, 0.3)).timeout
	bobbing()


func bobbing():
	var time = randf_range(0.45, 0.8)
	tween_bobbing = create_tween().set_loops() 
	tween_bobbing.tween_property(animation, "position", Vector2(0, 110), time)
	tween_bobbing.tween_property(animation, "position", Vector2(0, 60), time)
	tween_shadow = create_tween().set_loops() 
	tween_shadow.tween_property(shadow, "scale", Vector2(0.35, 0.35), time)
	tween_shadow.tween_property(shadow, "scale", Vector2(0.25, 0.25), time)

func start_quest():
	Trackers.add_quest(task)

#dialogue and quest
func _on_button_pressed() -> void:
	if player_detected == true and dialogue != null:
		DialogueManager.show_dialogue_balloon(dialogue, "start")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bottom"):
		tap_to_chat.show()
		var shader = preload("res://outline.gdshader")
		var material = ShaderMaterial.new()
		material.shader = shader
		
		animation.material = material
		player_detected = true
		
#outline
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_bottom"):
		tap_to_chat.hide()
		animation.material = null
		player_detected = false
		
func just_released(number : int):
	animation.play("dizzy")
	animation.pause()
	animation.frame = number
	var tween = create_tween().set_loops() 
	tween.tween_property(animation, "rotation_degrees", 10, 0.4)
	tween.tween_property(animation, "rotation_degrees", -10, 0.4)
	possessable = false
	await get_tree().create_timer(2.0).timeout
	tween.kill()
	animation.rotation = 0
	letter = letter_list.pick_random()
	animation.play(letter)
	animation.pause()
	animation.frame = number
	possessable = true
	bobbing()
