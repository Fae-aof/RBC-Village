extends RigidBody2D

var snap_area: Area2D = null
var dragging = false
var offset = Vector2.ZERO

func _ready() -> void:
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC

func _process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - offset

func _on_top_edge_area_entered(area: Area2D) -> void:
	if area.get_parent() == self:
		return
	snap_area = area

func _on_top_edge_area_exited(area: Area2D) -> void:
	if area == snap_area:
		snap_area = null

func _on_button_button_down() -> void:
	dragging = true
	freeze = true
	offset = get_global_mouse_position() - global_position

func _on_button_button_up() -> void:
	dragging = false
	if snap_area != null:
		var other = snap_area.get_parent()
		global_position = snap_area.global_position
		global_rotation = other.global_rotation

		var joint = PinJoint2D.new()
		get_parent().add_child(joint)
		joint.global_position = snap_area.global_position
		joint.node_a = joint.get_path_to(self)
		joint.node_b = joint.get_path_to(other)
		snap_area = null
	freeze = false


		#if cnt != null:
			#position = cnt
			#reparent(obj, false)
			#rotation = obj.rotation
			#var pinjoint = PinJoint2D.new()
			#get_parent().add_child(pinjoint)
			#pinjoint.node_a = pinjoint.get_path_to(self)
			#pinjoint.node_b = pinjoint.get_path_to(obj)
			#cnt = null
