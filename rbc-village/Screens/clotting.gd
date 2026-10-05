extends Node2D


func _on_calcium_body_entered(body: Node2D) -> void:
	print("checking")
	if body.is_in_group("prothrombin"):
		print("check")
		body.convert()
