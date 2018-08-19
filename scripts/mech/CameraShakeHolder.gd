extends Spatial

var magnitude = 0
var timeLeft = 0
var is_shaking = false

#var walk_shake_magnitude = 0.003
var walk_shake_magnitude = 0.001
var walk_shake_lifetime = 1.5

#var jog_shake_magnitude = 0.004
var jog_shake_magnitude = 0.0015
var jog_shake_lifetime = 1.3

#var run_shake_magnitude = 0.005
var run_shake_magnitude = 0.002
var run_shake_lifetime = 1.1

var delta_time = get_process_delta_time()

func _ready():
	pass

func _process(delta):
	if timeLeft > 0:
		rotation.x = rand_range(-magnitude, magnitude)
#		rotation.y = rand_range(-magnitude, magnitude)
		rotation.z = rand_range(-magnitude, magnitude)
		timeLeft -= 0.1
	
	if timeLeft < 0:
		timeLeft = 0
	
	if timeLeft == 0:
		rotation.x = 0
#		rotation.y = 0
		rotation.z = 0

#func _physics_process(delta):
#	if timeLeft > 0:
#		translation.y = rand_range(-magnitude, magnitude)
#
#	if timeLeft > 0:
#		timeLeft -= 0.1

	
#	aimpoint_unprojected = unproject_position(cam_aimpoint)
	
#	if Input.is_action_pressed("look_zoom"):
#		shake(0.05, 5)
#	camera_sway(delta, foot)
##	sway_step(0, delta)
##	translate_object_local(Vector3(get_parent().get_parent().get_parent().translation.x * 0.01, get_parent().get_parent().translation.y * -0.01, 0))
##	translate_object_local(Vector3(10, 10, 10))
#
#func sway_step(foot):
##	camera_sway(delta, foot)
##	if keyframe == 0:
##		translation.x += 0.01
##		translation.y += -0.01
##	translate_object_local(Vector3(10, 10, 10))
##		translate_object_local(Vector3(0.01, -0.01, 0))
##		translate_object_local(Vector3(get_parent().get_parent().get_parent().get_parent().translation.x * 0.01, get_parent().get_parent().translation.y * -0.01, 0))
#
#func camera_sway(delta, foot):
#	if foot == "right":
#		translation.x += 0.01
#		translation.y += 0.01

func shake(set):
#	if magnitude > new_magnitude: return
	if set == 1:
		magnitude = walk_shake_magnitude
		timeLeft = walk_shake_lifetime
	elif set == 2:
		magnitude = jog_shake_magnitude
		timeLeft = jog_shake_lifetime
	elif set == 3:
		magnitude = run_shake_magnitude
		timeLeft = run_shake_lifetime

#	if is_shaking: return
#	is_shaking = true

#	if timeLeft > 0:
#		var pos = Vector2()
#		translation.x = rand_range(-magnitude, magnitude)
#		translation.y = rand_range(-magnitude, magnitude)
#		timeLeft -=0.1
#		print(timeLeft)
#        yield(get_tree(),"idle_frame")

#	magnitude = 0
#	is_shaking = false
#    position = Vector2(0,0)
#	pass