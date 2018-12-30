extends Camera

const MOUSE_SENSITIVITY = 0.05

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

#Receives mouse movement input moving the camera view. Escape toggles mouselock.
func _input(event):
	#If the passed event was mouse motion, and the mouse is currently captured
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		if Input.is_action_pressed("freelook"):
					#Move the camera gimbal from side to side, clamp to the limited range.
	#		cam_gimbal.rotation_degrees.y = clamp(cam_gimbal.rotation_degrees.y, -30, 30)
	#		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -10, 20)
			var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
			var new_rot_y_2 = get_rotation_degrees().y + horizontal_rotation
			set_rotation_degrees(Vector3(0, new_rot_y_2, 0))
			#Move the camera itself up and down, clamp again
			#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
			var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
			var new_rot_x_2 = get_rotation_degrees().x + vertical_rotation
			set_rotation_degrees(Vector3(new_rot_x_2, 0, 0))

			#Emit update signal to turret. First, assemble the camera's quaternion,
			# relative to the tank base. Slightly messy since it has two rotating parts.
#			var cam_quat = Quat(camera.get_transform().basis)
#	#		var cam_quat = Quat(Vector3(1, 0, 0), new_rot_x * -0.01)
#			var gimbal_quat = Quat(cam_gimbal.get_transform().basis)
#			var combined_quat = Quat(Vector3(0, 1, 0), deg2rad(new_rot_y)) * Quat(Vector3(-1, 0, 0), deg2rad(new_rot_x))
#	#		var combined_quat = Quat(Vector3(0, 0, 1), PI) * gimbal_quat * cam_quat
#			emit_signal("camera_position_updated", cam_quat, gimbal_quat, combined_quat)

		else:
			#Move the camera gimbal from side to side, clamp to the limited range.
	#		cam_gimbal.rotation_degrees.y = clamp(cam_gimbal.rotation_degrees.y, -30, 30)
	#		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -10, 20)
			var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
			var new_rot_y = get_rotation_degrees().y + horizontal_rotation
			set_rotation_degrees(Vector3(0, new_rot_y, 0))
			#Move the camera itself up and down, clamp again
			#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
			var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
			var new_rot_x = get_rotation_degrees().x + vertical_rotation
			set_rotation_degrees(Vector3(new_rot_x, -180, 0))

			#Emit update signal to turret. First, assemble the camera's quaternion,
			# relative to the tank base. Slightly messy since it has two rotating parts.
#            var cam_quat = Quat(camera.get_transform().basis)
	#		var cam_quat = Quat(Vector3(1, 0, 0), new_rot_x * -0.01)
#            var gimbal_quat = Quat(cam_gimbal.get_transform().basis)
#            var combined_quat = Quat(Vector3(0, 1, 0), deg2rad(new_rot_y)) * Quat(Vector3(-1, 0, 0), deg2rad(new_rot_x))
	#		var combined_quat = Quat(Vector3(0, 0, 1), PI) * gimbal_quat * cam_quat
#            emit_signal("camera_position_updated", cam_quat, gimbal_quat, combined_quat)