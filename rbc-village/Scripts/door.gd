extends Node2D

@onready var button = get_node("Button")

var player_detected = false

#teleport to tunnel code scene
func _on_button_pressed() -> void:
	if player_detected == true:
		get_tree().change_scene_to_file("res://Screens/tunnl_code.tscn")

#outlines
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bottom"):
		var shader = preload("res://outline.gdshader")
		var material = ShaderMaterial.new()
		material.shader = shader
		
		button.material = material
		player_detected = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_bottom"):
		button.material = null
		player_detected = false
		
