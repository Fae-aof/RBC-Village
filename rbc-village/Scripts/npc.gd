extends Node2D

@onready var button: Button = $Button
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var letter: String 
@onready var text_box: CanvasLayer = $"Text Box"


var player_detected = false
@export var quest_available = false
@export var quest_completer = false
@export var task = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play(letter)

#dialogue and quest
func _on_button_pressed() -> void:
	if player_detected == true:
		text_box.show()
		text_box.start_dialogue()
		if quest_available == true:
			Trackers.add_quest(task)
		if quest_completer == true:
			print(Trackers.quest_dict[task])
			Trackers.finish_quest(task)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bottom"):
		var shader = preload("res://outline.gdshader")
		var material = ShaderMaterial.new()
		material.shader = shader
		
		animation.material = material
		player_detected = true
		
#outline
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_bottom"):
		animation.material = null
		player_detected = false
