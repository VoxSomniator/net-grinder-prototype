extends Node

var ground_speed = 0

var throttle_setting = 0

var max_forward_speed = 0

var max_reverse_speed = 0

var max_torso_yaw = 0
var max_torso_pitch = 0

var torso_pitch = 0
var torso_yaw = 0

var torso_aimpoint_2d = Vector2()
var arm_aimpoint_2d = Vector2()

var arm_aim

var arm_aim_distance = 0

var torso_heading = 0

var body = NodePath()

var camera = NodePath()

var body_pos = Vector2()

#var starting_navpoint

var active_navpoint

signal navpoint_reached(navpoint, hide_on_reached, switch_on_reached)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass