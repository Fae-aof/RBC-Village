extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var npc_node = preload("res://Prefabs/npc.tscn")
@onready var player_node = preload("res://Prefabs/player.tscn")

@export var speed: float = 500.0

var possessable_npc = []

func _ready() -> void:
	animation.play("floating")
	UI.connect("possess_npc", possess_npc)
	
func _process(delta: float) -> void:
	if Trackers.dialogue_active == true:
		speed = 0
	else:
		speed = 300.0

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false

	if Trackers.oxygen >= 100 and animation.animation != "oxygenated":
		animation.play("oxygenated")

func _physics_process(_delta):
	get_input()
	move_and_slide()
	


func _on_full_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("npc"):
		if area.get_parent().possessable:
			possessable_npc.append(area.get_parent())
			UI.get_node("Possess").show()


func _on_full_area_area_exited(area: Area2D) -> void:
	if possessable_npc.has(area.get_parent()):
		possessable_npc.erase(area.get_parent())
		if possessable_npc == []:
			UI.get_node("Possess").hide()

func possess_npc():
	var new_npc = npc_node.instantiate()
	new_npc.global_position = global_position
	get_parent().add_child(new_npc)
	new_npc.just_released()
	var new_player = player_node.instantiate()
	new_player.global_position = possessable_npc[0].global_position
	get_parent().add_child(new_player)
	
	var new_cam = new_player.get_node("Camera2D")
	var old_cam = get_node("Camera2D")
	new_cam.global_position = old_cam.global_position
	var tween = create_tween()
	tween.tween_property(new_cam, "position", new_player.global_position, 1)
	
	possessable_npc[0].queue_free()
	queue_free()
