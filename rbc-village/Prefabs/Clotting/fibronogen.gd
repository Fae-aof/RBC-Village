extends RigidBody2D

@export var attract_strength := 3000.0
@export var attract_range := 300.0
@export var connect_distance := 14.0
@export var max_chain_length := 10
@export var straighten_strength := 1000.0   # torque pulling neighbours into a straight line

@onready var ends: Array[Marker2D] = [$TopEnd, $BottomEnd]
@onready var sprite: Sprite2D = $Sprite2D

var linkable = false

var used := [false, false]   # is this end already pinned to something?
var linked := []             # bodies directly joined to this one
var link_ends := {}          # body -> [my_end, other_end] for that joint

func enable_link():
	print("convert")
	linkable = true
	remove_from_group("fibronogen")

func _ready() -> void:
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	gravity_scale = 0.0
	linear_damp = 2.0
	angular_damp = 3.0

# Every body reachable through joints, including self
func _get_chain() -> Array:
	var visited := [self]
	var stack := [self]
	while not stack.is_empty():
		var cur = stack.pop_back()
		for n in cur.linked:
			if n not in visited:
				visited.append(n)
				stack.append(n)
	return visited

# Angle needed to make this body continue in the same direction as 'other'
# when my_end touches other_end. 0 = perfectly straight.
func _straight_error(my_end: int, other, other_end: int) -> float:
	var u: Vector2 = ends[my_end].global_position - ends[1 - my_end].global_position
	var v: Vector2 = other.ends[1 - other_end].global_position - other.ends[other_end].global_position
	return u.angle_to(v)

func _physics_process(_delta: float) -> void:
	# 1) keep existing links straight (runs for every body)
	for other in link_ends:
		if not is_instance_valid(other):
			continue
		var e: Array = link_ends[other]
		apply_torque(_straight_error(e[0], other, e[1]) * straighten_strength)

	if not linkable:
		return

	# 2) look for new connections
	for i in 2:
		if used[i]:
			continue

		var my_chain := _get_chain()

		var best_body = null
		var best_j := -1
		var best_dist := attract_range
		var my_pos := ends[i].global_position

		for other in get_tree().get_nodes_in_group("chain"):
			if other in my_chain:     # same chain -> would form a loop
				continue
			# joining the two chains must not exceed the limit
			if my_chain.size() + other._get_chain().size() > max_chain_length:
				continue
			for j in 2:
				if other.used[j]:     # that end is already taken
					continue
				var d := my_pos.distance_to(other.ends[j].global_position)
				if d < best_dist:
					best_dist = d
					best_body = other
					best_j = j

		if best_body == null:
			continue

		if best_dist <= connect_distance:
			_connect(i, best_body, best_j)
			continue

		var target: Vector2 = best_body.ends[best_j].global_position
		var closeness := 1.0 - best_dist / attract_range
		apply_force((target - my_pos).normalized() * attract_strength * closeness, my_pos - global_position)
		# line up with the target so the join is straight
		apply_torque(_straight_error(i, best_body, best_j) * straighten_strength * closeness)

func _connect(my_end: int, other, other_end: int) -> void:
	# final safety checks right before creating the joint
	var my_chain := _get_chain()
	if used[my_end] or other.used[other_end] or other in my_chain:
		return
	if my_chain.size() + other._get_chain().size() > max_chain_length:
		return

	var joint := PinJoint2D.new()
	get_parent().add_child(joint)
	joint.global_position = (ends[my_end].global_position + other.ends[other_end].global_position) / 2.0
	joint.node_a = joint.get_path_to(self)
	joint.node_b = joint.get_path_to(other)

	used[my_end] = true
	other.used[other_end] = true
	linked.append(other)
	other.linked.append(self)
	link_ends[other] = [my_end, other_end]
	other.link_ends[self] = [other_end, my_end]

	# connected pieces become fully opaque
	sprite.modulate = Color.WHITE
	other.sprite.modulate = Color.WHITE
