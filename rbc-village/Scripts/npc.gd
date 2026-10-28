extends Node2D

@onready var button: Button = $Button
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var letter: String 
@onready var tap_to_chat: Label = $"Tap to Chat"

var player_detected = false
@export var possessable = true
@export var task: Quest
var letter_list = ["A", "B", "C", "D"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play(letter)

func start_quest():
	Trackers.add_quest(task)

#dialogue and quest
func _on_button_pressed() -> void:
	if player_detected == true:
		DialogueManager.show_dialogue_balloon(get_meta("DialogueRes"), "start")

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
		
func just_released():
	animation.play("dizzy")
	possessable = false
	await get_tree().create_timer(2.0).timeout
	letter = letter_list.pick_random()
	animation.play(letter)
	possessable = true
