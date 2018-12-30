extends KinematicBody

var max_forward_speed = 20
var max_reverse_speed = -10
var acceleration = 1.5
var deceleration = 0.5
var accel = 0
var accel_zoned = 0

var turn_speed = 1
var transverse_speed = 0.05

var max_slope_angle = 45

var throttle_setting = 0
var throttle_setting_percentage = 0
var ground_speed = 0

var mouse_sensitivity = 0.3

onready var freelook_holder_y = $FreelookY
onready var freelook_holder_x = $FreelookY/FreelookX
onready var camera_holder = $FreelookY/FreelookX/CameraHolder
onready var camera = $FreelookY/FreelookX/CameraHolder/Camera

var vel = Vector3()
var dir = Vector3()

#Parts
onready var turret = $Turret

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	turn_turret(delta)
	process_freelook(delta)
	process_hud(delta)

func process_input(delta):
	#Throttle stuff
	var tank_xform = self.global_transform
	dir = Vector3()
	var input_movement_vector = Vector2()

	throttle_setting = clamp(throttle_setting, max_reverse_speed, max_forward_speed)
	if Input.is_action_pressed("movement_forward"):
		if throttle_setting >= 0:
			throttle_setting += (max_forward_speed * 0.01)
#            throttle_setting += 1
		elif throttle_setting < 0:
			throttle_setting -= (max_reverse_speed * 0.01)
	if Input.is_action_pressed("movement_backward"):
		if throttle_setting > 0:
			throttle_setting -= (max_forward_speed * 0.01)
		elif throttle_setting <= 0:
			throttle_setting += (max_reverse_speed * 0.01)

	if Input.is_action_just_pressed("throttle_max"):
		throttle_setting = max_forward_speed

	if Input.is_action_just_pressed("reverse_max"):
		throttle_setting = max_reverse_speed

	if Input.is_action_just_pressed("throttle_zero"):
		throttle_setting = 0

	if throttle_setting > 0:
		input_movement_vector.y += 1
		throttle_setting_percentage = (throttle_setting / max_forward_speed) * 100
	if throttle_setting < 0:
		input_movement_vector.y += 1
		throttle_setting_percentage = (throttle_setting / max_reverse_speed) * 100

	if throttle_setting == 0:
		throttle_setting_percentage = 0

	input_movement_vector = input_movement_vector.normalized()

	dir += tank_xform.basis.z.normalized() * input_movement_vector.y

	#Turn stuff
#	turn_vector.y = 0
#	angular_velocity.y = clamp(turn_vector.y, turn_speed * -1, turn_speed)
	if Input.is_action_pressed("movement_left"):
#		turn_vector.y = turn_speed
		rotate_y(deg2rad(turn_speed))
#	else:
#		turn_vector.y = 0
	if Input.is_action_pressed("movement_right"):
#		turn_vector.y = turn_speed * -1
		rotate_y(deg2rad(turn_speed * -1))
#	else:
#		turn_vector.y = 0
#	if InputEventMouseMotion:
#		var horizontal_rotation = event.relative.x * mouse_sensitivity * -1
#		var new_rot_y = camera_holder.get_rotation_degrees().y + horizontal_rotation
#		camera_holder.set_rotation_degrees(Vector3(0, new_rot_y, 0))
		#Move the camera itself up and down, clamp again
		#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
#		var vertical_rotation = event.relative.y * mouse_sensitivity * -1
#		var new_rot_x = camera.get_rotation_degrees().x + vertical_rotation
#		camera.set_rotation_degrees(Vector3(new_rot_x, -180, 0))

func process_movement(delta):
	dir = dir.normalized()

	var target = dir
	target *= throttle_setting

	var forward_vector = self.global_transform.basis.z.normalized()
	ground_speed = forward_vector.dot(vel)

#	var accel
	if ground_speed < throttle_setting:
		if throttle_setting > 0:
			if ground_speed > 0:
				accel = acceleration
			elif ground_speed < 0:
				accel = deceleration
	elif ground_speed > throttle_setting:
		if throttle_setting < 0:
			if ground_speed > 0:
				accel = deceleration
			elif ground_speed < 0:
				accel = acceleration

#	elif ground_speed < throttle_setting:
#		if throttle_setting < 0:
#			if ground_speed < 0:
#				accel = deceleration
#	elif ground_speed > throttle_setting:
#		if throttle_setting < 0:
#			if ground_speed < 0:
#				accel = acceleration

	if throttle_setting == 0:
		accel = deceleration

#	var accel_zoned
	if throttle_setting_percentage < 10:
		if ground_speed == 0:
			accel_zoned = 0
	else:
		accel_zoned = accel


#	vel = vel.linear_interpolate(target, acceleration * delta)

#	speed_vector.z = 1
#	speed_vector *= throttle_setting
	vel = vel.linear_interpolate(target, acceleration * delta)
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(max_slope_angle))
#	throttle = linear_velocity.z
#	print(forward_vector)

func turn_turret(delta):
	var turret_quat = Quat(turret.transform.basis).normalized()
	var camera_holder_quat = Quat(Vector3(0, 1, 0), camera_holder.rotation.y).normalized()
	var camera_quat = Quat(Vector3(-1, 0, 0), camera.rotation.x).normalized()
	var combined_quat = camera_holder_quat * camera_quat
	var turret_transform_rotation = Transform(turret_quat.slerp(combined_quat, transverse_speed))
	turret_transform_rotation.origin = turret.transform.origin
	turret.transform = turret_transform_rotation

func process_freelook(delta):
	#Freelook quaternions
	var freelook_holder_y_quat = Quat(Vector3(0, 1, 0), freelook_holder_y.rotation.y)
	var freelook_holder_x_quat = Quat(Vector3(1, 0, 0), freelook_holder_x.rotation.x)
#	var combined_freelook_quat = freelook_holder_quat_x # * freelook_holder_quat_y
#	var camera_quat = Quat(Vector3(1, 0, 0), camera.rotation.x).normalized()
	var zero_quat = Quat(Vector3(1, 1, 0), 0)

	var freelook_holder_y_quat_rotation = Transform(freelook_holder_y_quat.slerp(zero_quat, 0.02))
#	var camera_quat_rotation = Transform(camera_quat.slerp(zero_quat, 0.2))

#	freelook_holder_quat_rotation.origin = freelook_holder.transform.origin
#	camera_quat_rotation.origin = camera.transform.origin

	#Face forward again when freelook is released
	if not Input.is_action_pressed("freelook"):
		freelook_holder_y.transform = freelook_holder_y_quat_rotation
#		camera.transform = camera_quat_rotation

func process_hud(delta):
	$HUD/Throttle.text = "Max forward speed: " + str(max_forward_speed) + "\n" \
	+ "Max reverse speed: " + str(max_reverse_speed) + "\n" \
	+ "Throttle setting: " + str(throttle_setting) + "\n" \
	+ "Throttle setting percentage: " + str(throttle_setting_percentage) + "%" + "\n" \
	+ "Throttle: " + str(ground_speed) + "\n" \
	+ "Accel: " + str(accel) + "\n" \
	+ "Accel zoned: " + str(accel_zoned)
#	+ "Throttle: " + str(self.global_transform.basis.z.normalized().dot(vel))

#Receives mouse movement input moving the camera view. Escape toggles mouselock.
func _input(event):
	#If the passed event was mouse motion, and the mouse is currently captured
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		if Input.is_action_pressed("freelook"):
					#Move the camera gimbal from side to side, clamp to the limited range.
	#		camera_holder.rotation_degrees.y = clamp(camera_holder.rotation_degrees.y, -30, 30)
	#		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -10, 20)
			var horizontal_rotation_freelook = event.relative.x * mouse_sensitivity * -1
			var new_rot_y_freelook = freelook_holder_y.get_rotation_degrees().y + horizontal_rotation_freelook
			freelook_holder_y.set_rotation_degrees(Vector3(0, new_rot_y_freelook, 0))
			#Move the camera itself up and down, clamp again
			#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
			var vertical_rotation_freelook = event.relative.y * mouse_sensitivity * -1
			var new_rot_x_freelook = freelook_holder_x.get_rotation_degrees().x + vertical_rotation_freelook
			freelook_holder_x.set_rotation_degrees(Vector3(new_rot_x_freelook, new_rot_y_freelook, 0))

			#Emit update signal to turret. First, assemble the camera's quaternion,
			# relative to the tank base. Slightly messy since it has two rotating parts.
#			var cam_quat = Quat(camera.get_transform().basis)
#	#		var cam_quat = Quat(Vector3(1, 0, 0), new_rot_x * -0.01)
#			var gimbal_quat = Quat(camera_holder.get_transform().basis)
#			var combined_quat = Quat(Vector3(0, 1, 0), deg2rad(new_rot_y)) * Quat(Vector3(-1, 0, 0), deg2rad(new_rot_x))
#	#		var combined_quat = Quat(Vector3(0, 0, 1), PI) * gimbal_quat * cam_quat
#			emit_signal("camera_position_updated", cam_quat, gimbal_quat, combined_quat)

		else:
			#Move the camera gimbal from side to side, clamp to the limited range.
	#		camera_holder.rotation_degrees.y = clamp(camera_holder.rotation_degrees.y, -30, 30)
			camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -50, 50)
			var horizontal_rotation = event.relative.x * mouse_sensitivity * -1
			var new_rot_y = camera_holder.get_rotation_degrees().y + horizontal_rotation
			camera_holder.set_rotation_degrees(Vector3(0, new_rot_y, 0))
			#Move the camera itself up and down, clamp again
			#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
			var vertical_rotation = event.relative.y * mouse_sensitivity * -1
			var new_rot_x = camera.get_rotation_degrees().x + vertical_rotation
			camera.set_rotation_degrees(Vector3(new_rot_x, -180, 0))

			#Emit update signal to turret. First, assemble the camera's quaternion,
			# relative to the tank base. Slightly messy since it has two rotating parts.
#			var cam_quat = Quat(camera.get_transform().basis)
	#		var cam_quat = Quat(Vector3(1, 0, 0), new_rot_x * -0.01)
#			var gimbal_quat = Quat(camera_holder.get_transform().basis)
#			var combined_quat = Quat(Vector3(0, 1, 0), deg2rad(new_rot_y)) * Quat(Vector3(-1, 0, 0), deg2rad(new_rot_x))
	#		var combined_quat = Quat(Vector3(0, 0, 1), PI) * gimbal_quat * cam_quat
