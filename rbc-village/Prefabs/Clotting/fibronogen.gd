extends RigidBody2D

class Chain:
	var members: Array = []

@export var attract_strength := 3000.0
@export var attract_range := 400.0
@export var connect_distance := 14.0
@export var max_chain_length := 20
@export var straighten_strength := 1000.0
@export var drift_speed := 40.0            # idle float speed (px/s, decays with linear_damp)

const SEARCH_INTERVAL := 0.25
const CELL_SIZE := 400.0                   # keep >= attract_range + rectangle length

static var grid := {}                      # Vector2i -> Array of bodies (needs Godot 4.1+)

@onready var ends: Array[Marker2D] = [$TopEnd, $BottomEnd]
@onready var sprite: Sprite2D = $Sprite2D
@onready var fibrin_sprite = preload("res://Milestone 3 Sprites/better clotting sprites/fibrin.png")

var linkable := false

var chain := Chain.new()
var used := [false, false]
var linked := []
var link_ends := {}                        # body -> [my_end, other_end]

var targets := [null, null]                # cached target body per end
var target_ends := [0, 0]                  # which end of that body

var cell := Vector2i.ZERO
var registered := false
var search_cd := randf() * SEARCH_INTERVAL
var drift_cd := randf_range(0.0, 3.0)

func _ready() -> void:
	chain.members.append(self)
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	gravity_scale = 0.0
	linear_damp = 2.0
	angular_damp = 3.0
	_update_grid()

func _exit_tree() -> void:
	if registered and grid.has(cell):
		grid[cell].erase(self)

func enable_link() -> void:
	linkable = true
	sprite.texture = fibrin_sprite
	Trackers.fibrin_counter += 1
	remove_from_group("fibronogen")

# --- spatial grid ---------------------------------------------------------

func _update_grid() -> void:
	var new_cell := Vector2i((global_position / CELL_SIZE).floor())
	if registered and new_cell == cell:
		return
	if registered and grid.has(cell):
		grid[cell].erase(self)
	cell = new_cell
	if not grid.has(cell):
		grid[cell] = []
	grid[cell].append(self)
	registered = true

# --- helpers ----------------------------------------------------------------

# Angle needed to continue in the same direction as 'other'. 0 = straight.
func _straight_error(my_end: int, other, other_end: int) -> float:
	var u: Vector2 = ends[my_end].global_position - ends[1 - my_end].global_position
	var v: Vector2 = other.ends[1 - other_end].global_position - other.ends[other_end].global_position
	return u.angle_to(v)

func _find_targets() -> void:
	var my_size := chain.members.size()
	targets[0] = null
	targets[1] = null
	if my_size >= max_chain_length:
		return

	for i in 2:
		if used[i]:
			continue
		var my_pos := ends[i].global_position
		var best_dist := attract_range

		for dx in range(-1, 2):
			for dy in range(-1, 2):
				var bucket = grid.get(cell + Vector2i(dx, dy))
				if bucket == null:
					continue
				for other in bucket:
					if other.chain == chain:
						continue   # same chain (also skips self) -> would form a loop
					if my_size + other.chain.members.size() > max_chain_length:
						continue
					for j in 2:
						if other.used[j]:
							continue
						var d := my_pos.distance_to(other.ends[j].global_position)
						if d < best_dist:
							best_dist = d
							targets[i] = other
							target_ends[i] = j

func _drift(delta: float) -> void:
	drift_cd -= delta
	if drift_cd <= 0.0:
		drift_cd = randf_range(2.0, 5.0)
		linear_velocity = Vector2.from_angle(randf() * TAU) * randf_range(drift_speed * 0.5, drift_speed)
		angular_velocity = randf_range(-0.3, 0.3)

# --- main loop -----------------------------------------------------------

func _physics_process(delta: float) -> void:
	# 1) keep existing links straight
	for other in link_ends:
		if not is_instance_valid(other):
			continue
		var e: Array = link_ends[other]
		apply_torque(_straight_error(e[0], other, e[1]) * straighten_strength)

	# 2) throttled work: refresh grid cell and look for targets
	search_cd -= delta
	if search_cd <= 0.0:
		search_cd = SEARCH_INTERVAL + randf() * 0.1
		_update_grid()
		if linkable:
			_find_targets()

	if not linkable:
		_drift(delta)
		return

	# 3) pull toward cached targets (cheap, every frame)
	for i in 2:
		var other = targets[i]
		if other == null:
			continue
		var j: int = target_ends[i]
		if not is_instance_valid(other) or used[i] or other.used[j]:
			targets[i] = null
			continue

		var my_pos := ends[i].global_position
		var target: Vector2 = other.ends[j].global_position
		var dist := my_pos.distance_to(target)

		if dist <= connect_distance:
			_connect(i, other, j)
			targets[i] = null
			continue

		var closeness := 1.0 - dist / attract_range
		if closeness <= 0.0:
			targets[i] = null
			continue
		apply_force((target - my_pos).normalized() * attract_strength * closeness, my_pos - global_position)
		apply_torque(_straight_error(i, other, j) * straighten_strength * closeness)

func _connect(my_end: int, other, other_end: int) -> void:
	# final safety checks right before creating the joint
	if used[my_end] or other.used[other_end] or other.chain == chain:
		return
	if chain.members.size() + other.chain.members.size() > max_chain_length:
		return

	sprite.texture = fibrin_sprite
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

	# merge the two chains into one shared object
	var other_chain: Chain = other.chain
	for m in other_chain.members:
		m.chain = chain
	chain.members.append_array(other_chain.members)

	sprite.modulate = Color.WHITE
	other.sprite.modulate = Color.WHITE
