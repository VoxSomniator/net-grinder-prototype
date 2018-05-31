extends Camera

signal heading_updated(heading)
signal aimpoint_unprojected_updated(aimpoint_unprojected)

var heading
var cam_aimpoint
var aimpoint_unprojected
var foot
var magnitude = 0
var timeLeft = 0
var is_shaking = false
var delta_time = get_process_delta_time()

func _ready():
#	shake(1, 1, delta_time)
	pass

func _process(delta):
	heading = rad2deg(Vector2(global_transform.basis.z.x, global_transform.basis.z.z).angle_to(Vector2(0,1)))
	if heading < 0:
		heading += 360 # beautify heading, remove negative angle
	emit_signal("heading_updated", heading)
	
#	aimpoint_unprojected = unproject_position(cam_aimpoint)
	
	if Input.is_action_pressed("look_zoom"):
		shake(0.1, 2, delta)
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

func shake(new_magnitude, lifetime, delta):
	if magnitude > new_magnitude: return

	magnitude = new_magnitude
	timeLeft = lifetime

	if is_shaking: return
	is_shaking = true

	while timeLeft > 0:
#		var pos = Vector2()
		translation.x = rand_range(-magnitude, magnitude)
		translation.y = rand_range(-magnitude, magnitude)
		timeLeft -=0.1
#		print(timeLeft)
#        yield(get_tree(),"idle_frame")

	magnitude = 0
	is_shaking = false
#    position = Vector2(0,0)
	pass

func _on_Aimpoint_aimpoint_updated(new_aimpoint):
	cam_aimpoint = new_aimpoint
	aimpoint_unprojected = unproject_position(cam_aimpoint)
	emit_signal("aimpoint_unprojected_updated", aimpoint_unprojected)
#	print("updated aimpoint", cam_aimpoint)
