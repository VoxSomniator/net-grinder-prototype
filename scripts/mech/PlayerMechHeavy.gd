extends RigidBody

#A player-controlled tank.
#Currently, moves around, controlled by master player or signals from other masters.
#Uses rigidbody instead of kinematicbody, because big bulky vehicles should have physics.
#Kinematicbody lacks the inertia and rotation and everything.

#Emitted when this tank becomes the active player, makes its camera current.
#Used instead of a direct path call so the camera can be rearranged safely.
signal camera_activated()
#Holds ref to the camera gimbal object
var cam_gimbal
var cam_gimbal_2
#holds ref to the camera object
var camera
var camera_2
#Holds a ref to the turret skeleton thing. Used by camera.
var skeleton
#How fast the mouse moves the camera
const MOUSE_SENSITIVITY = 0.05
#Maximum rotation angles of the camera
const CAM_Y_RANGE = 45
const CAM_X_RANGE = 45
#Signal emitted by camera to update turret's position
signal camera_position_updated(cam_quat, gimbal_quat, combined_quat)

#Heading, pitch and roll signals
signal body_heading_updated(body_heading)
signal pitch_updated(pitch)
signal roll_updated(roll)

#Body global transform and heading variables
var body_xform
var body_heading
var pitch
var roll
var body_quat
var body_xform_rotation
var torso_twist

signal altitude_updated(altitude)
signal elevation_updated(elevation)

var altitude
var elevation

var cam_quat
var cam_gimbal_quat

signal cam_quat_updated(cam_quat)
signal cam_gimbal_quat_updated(cam_gimbal_quat)
signal body_quat_upated(body_quat)
signal body_xform_rotation_updated(body_xform_rotation)
signal torso_twist_updated(torso_twist)

#HOW FAST can we go (forward/backward)
var max_forward_speed = 20
#How fast do we get going
var acceleration = 750
#Vector used for normal driving direction.
#Rigidbodies use world rotation, so this changes as the tank turns.
#By default it's set to upwards, so problems will be OBVIOUS
var forward_vector = Vector3(0, 1, 0)
var reverse_vector = Vector3(0, -1, 0)
#Used to total forces/accelerations and apply every frame. Still world coordinates.
var moving_vector = Vector3(0, 0, 0)

var lateral_vector = Vector3(1, moving_vector.y, 0)
var max_lateral_speed = 40

#How fast do we spin?
var turn_speed = 0.02
#Used to store rotation torque for physics processing
var turn_torque = Vector3(0, 0, 0)

var roll_speed = 0.02
#var roll_torque = Vector3(0, 0, 0)
#var roll_torque =  forward_vector

var transverse_speed = 0.05

signal throttle_updated(throttle, max_throttle, max_throttle_reverse, throttle_setting)
#signal throttle_setting_updated(throttle_setting)

var throttle
var max_throttle = 20
var max_throttle_reverse = max_throttle * -0.5
var throttle_setting

signal vertspeed_float_updated(vertspeed_float)
var max_vertical_thrust =  20
var vertical_acceleration = 2000
var vertspeed_float
var vertical_thrust_vector = Vector3(0, 1, 0)

signal speed_kph_float_updated(speed_kph_float)
var speed_kph_float

var forward_speed
var reverse_speed
var lateral_speed_left
var lateral_speed_right

#Maximum torso twist and pitch ranges, in degrees
var max_yaw = 100
var max_pitch_down = -15
var max_pitch_up = 20
signal max_rotation_ranges(max_yaw, max_pitch_down, max_pitch_up)

#Used only by instances of other players' tanks. Each player's master tank updates all the other slaves.
slave var other_transform

var start_jump = false
var max_jump_speed = 100
var in_freefall_up = false
var in_freefall_down = false
var in_freefall = false
var can_jump = true

#Utility Quat
onready var UtilityQuat = preload("res://scripts/UtilityQuat.gd")

#Heat
signal heat_updated(heat, heat_capacity, heat_dissipation_rate)

var heat
var heat_capacity = 10000
var heat_dissipation_rate = 1.5

#Weapons
var weapon_aimpoint
var weapon_position
var weapon_position_2
var weapon_position_3
var weapon_position_4
#var weapon_position_5
#var weapon_position_6
var weapon_positions

var weapon_mount
var weapon_mount_2
var weapon_mounts

var pulse_bolt

func _ready():
	#If this vehicle is the local player's, do some stuff
	if is_network_master():
		#Turn on its camera, which turns off the old one probably
		emit_signal("camera_activated")
		#Set up other camera stuff- Only in this section, otherwise, every other
		# player's tank would do this too and that might get wonky
		cam_gimbal = $TorsoGimbal/Gimbal2/CamGimbalY
		cam_gimbal_2 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/CameraHolder/CamGimbal2
		camera = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX
		camera_2 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/CameraHolder/CamGimbal2/CameraShakeHolder/Camera
		skeleton = $MechHeavy/Armature/Skeleton
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		set_process_input(true)
		throttle = 0
		throttle_setting = 0
		forward_speed = 0
		reverse_speed = 0
		weapon_position = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponPosition
		weapon_position_2 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponPosition2
		weapon_position_3 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponPosition3
		weapon_position_4 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponPosition4
#		weapon_position_5 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponPosition5
#		weapon_position_6 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponPosition6
		weapon_positions = [weapon_position, weapon_position_2, weapon_position_3, weapon_position_4]

		weapon_mount = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponMount
		weapon_mount_2 = $TorsoGimbal/Gimbal2/CamGimbalY/CamGimbalX/WeaponMount2
		weapon_mounts = [weapon_mount, weapon_mount_2]

		pulse_bolt = preload("res://scenes/weapons/PulseBolt.tscn")
		heat = 0
		emit_signal("max_rotation_ranges", max_yaw, max_pitch_down, max_pitch_up)
#		gravity_scale = 0

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_heat(delta)

func process_input(delta):
	if is_network_master():
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			#Move via throttle
			if Input.is_action_pressed("movement_forward"):
				if throttle_setting < max_throttle:
					throttle_setting += max_throttle * 0.01
			elif Input.is_action_pressed("movement_backward"):
				if throttle_setting > max_throttle_reverse:
					throttle_setting -= max_throttle * 0.01

			#Keep throttle within maximum values
			if throttle_setting > max_throttle:
				throttle_setting = max_throttle
			elif throttle_setting < max_throttle_reverse:
				throttle_setting = max_throttle_reverse

			if Input.is_action_just_pressed("throttle_zero"):
				throttle_setting = 0

			if Input.is_action_just_pressed("throttle_max"):
				throttle_setting = max_throttle

			if Input.is_action_pressed("movement_left"):
				rotate_object_local(Vector3(0, 1, 0), turn_speed)
	#			moving_vector += accelerate_left(body_xform.basis.x.normalized(), acceleration, delta, max_lateral_speed)
			elif Input.is_action_pressed("movement_right"):
				rotate_object_local(Vector3(0, 1, 0), turn_speed * -1)
	#			moving_vector += accelerate_right(body_xform.basis.x.normalized() * -1, acceleration, delta, max_lateral_speed)

			#Turn left/right
			if Input.is_action_pressed("ui_left"):
				turn_torque.y += turn_speed
			if Input.is_action_pressed("ui_right"):
				turn_torque.y -= turn_speed

			#Restrict rotation range
			cam_gimbal.rotation_degrees.y = clamp(cam_gimbal.rotation_degrees.y, max_yaw * -1, max_yaw)
			camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, max_pitch_down, max_pitch_up)

			#Restrict freelook range
			cam_gimbal_2.rotation_degrees.y = clamp(cam_gimbal_2.rotation_degrees.y, max_yaw * -1, max_yaw)
			camera_2.rotation_degrees.x = clamp(camera_2.rotation_degrees.x, -30, 30)

			#Freelook quaternions
			var cam_gimbal_2_quat = Quat(Vector3(0, 1, 0), cam_gimbal_2.rotation.y).normalized()
			var camera_2_quat = Quat(Vector3(1, 0, 0), camera_2.rotation.x).normalized()
			var zero_quat = Quat(Vector3(1, 1, 0), 0).normalized()

			var cam_gimbal_2_quat_rotation = Transform(cam_gimbal_2_quat.slerp(zero_quat, 0.2))
			var camera_2_quat_rotation = Transform(camera_2_quat.slerp(zero_quat, 0.2))

			cam_gimbal_2_quat_rotation.origin = cam_gimbal_2.transform.origin
			camera_2_quat_rotation.origin = camera_2.transform.origin

			#Face forward again when freelook is released
			if not Input.is_action_pressed("freelook"):
				cam_gimbal_2.transform = cam_gimbal_2_quat_rotation
				camera_2.transform = camera_2_quat_rotation

			#Snap camera back when freelook is released
	#		if not Input.is_action_pressed("freelook"):
	#			if cam_gimbal_2.rotation.y != 0:
	#				cam_gimbal_2.rotation.y = 0
	#			if camera_2.rotation.x != 0:
	#				camera_2.rotation.x = 0

			if Input.is_action_pressed("fire_selected_weapon"):
				for i in weapon_mounts:
					i.get_child(0).fire()

			if Input.is_action_pressed("fire_weapon_2"):
#				weapon_position_2.get_child(0).fire()
				for i in weapon_positions:
					i.get_child(0).fire()

func process_movement(delta):
	#If this is the locally-controlled tank, get inputs to move
	if is_network_master():
		#Set our forward vector properly
		forward_vector = global_transform.basis.z.normalized()
		reverse_vector = global_transform.basis.z.normalized()
		#Reset the "current forces" vector
		moving_vector = Vector3(0, 0, 0)
		#Resets "torque" vector
		turn_torque = Vector3(0, 0, 0)
		#Resets roll torque
#		roll_torque = Vector3(0, 0, 0)
#		roll_torque = global_transform.basis.z
#		roll_torque = forward_vector

#		self.rotation_degrees.z = 0


		#Drive forward, up to max speed
#		if Input.is_action_pressed("movement_forward"):
#			moving_vector = accelerate(forward_vector, acceleration, delta, max_forward_speed)
#		elif Input.is_action_pressed("movement_backward"):
#			moving_vector = accelerate(forward_vector, -1 * acceleration, delta, max_forward_speed)




		#Throttle
		throttle = clamp(throttle, forward_speed, forward_speed)

		if throttle_setting > 0:
			moving_vector += accelerate_forward(forward_vector, acceleration, delta, throttle_setting)
		if throttle_setting < 0:
			moving_vector -= accelerate_reverse(forward_vector, acceleration, delta, throttle_setting)

#		moving_vector = accelerate(forward_vector, acceleration, delta, throttle_setting)
		emit_signal("throttle_updated", throttle, max_throttle, max_throttle_reverse, throttle_setting)
#		emit_signal("throttle_setting_updated", throttle_setting)

#		moving_vector += accelerate(vertical_thrust_vector, 490, delta, 490)

		if Input.is_action_pressed("vtol_ascend"):
			moving_vector += accelerate_up(vertical_thrust_vector, vertical_acceleration, delta, max_vertical_thrust)
#
#		if Input.is_action_pressed("vtol_descend"):
#			moving_vector += accelerate_down(vertical_thrust_vector, -1 * vertical_acceleration, delta, max_vertical_thrust)

		speed_kph_float = get_transform().basis.xform_inv(get_linear_velocity()).z * 3.6
		emit_signal("speed_kph_float_updated", speed_kph_float)

		forward_speed = get_transform().basis.xform_inv(get_linear_velocity()).z
		reverse_speed = get_transform().basis.xform_inv(get_linear_velocity()).z * -1
		lateral_speed_left = get_transform().basis.xform_inv(get_linear_velocity()).x
		lateral_speed_right = get_transform().basis.xform_inv(get_linear_velocity()).x * -1

		vertspeed_float = get_transform().basis.xform_inv(get_linear_velocity()).y
		emit_signal("vertspeed_float_updated", vertspeed_float)

		#After all forces are calculated, apply the impulse.
		apply_impulse(Vector3(0, 0, 0), moving_vector*delta)

		#Send our tank's new coordinates to all the other games
		rset_unreliable("other_transform", global_transform)

		#Listen for esc keypress, toggle mouse lock/look
#		if Input.is_action_just_pressed("ui_cancel"):
#			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
#				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
##			else:
##				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		#Altitude and elevation
#		altitude = $GroundDetector.global_transform.origin.y
#		elevation = $GroundDetector.get_collision_point().distance_to(Vector3(0, $GroundDetector.global_transform.origin.y, 0))
#		elevation = $GroundDetector.get_collision_point().distance_to($GroundDetector.global_transform.origin)
#		elevation = $GroundDetector.get_collision_point().y
#		$GroundDetector.force_raycast_update()
		emit_signal("altitude_updated", altitude)
		emit_signal("elevation_updated", elevation)

		#Pitch
		pitch = rotation_degrees.x * -1
		emit_signal("pitch_updated", pitch)

		#Roll
		roll = rotation_degrees.z * -1
		emit_signal("roll_updated", roll)

		#Twist
		torso_twist = $"MechHeavy/Armature/Skeleton/body-upper".rotation_degrees.y * -1
		emit_signal("torso_twist_updated", torso_twist)

		#Body global transform and heading values
		body_xform = get_global_transform()
		body_heading = rad2deg(Vector2(body_xform.basis.z.x, body_xform.basis.z.z).angle_to(Vector2(0,1)))
		if body_heading < 0:
			body_heading += 360 # beautify heading, remove negative angle
		emit_signal("body_heading_updated", body_heading)

#		weapon_position.look_at(weapon_aimpoint, Vector3(0, 0, 1))

#		cam_quat = Quat(camera.get_transform().basis)
#		cam_gimbal_quat = Quat(cam_gimbal.get_transform().basis)
#
#		body_quat = Quat(global_transform.basis).normalized()
#
#		body_xform_rotation = Transform(body_quat.slerp(cam_gimbal_quat, transverse_speed))
#
#		#Make sure the new transform has the right origin
#		body_xform_rotation.origin = body_xform.origin
#		#Replace it
#		body_xform = body_xform_rotation
#
#		emit_signal("cam_gimbal_quat_updated", cam_gimbal_quat)
#		emit_signal("cam_quat_updated", cam_quat)
#		emit_signal("body_quat_upated", body_quat)
#		emit_signal("body_xform_rotation_updated", body_xform_rotation)

	else:
		#If this is the slave tank to another player
		global_transform = other_transform

func process_heat(delta):
	if heat > 0:
		heat -= heat_dissipation_rate
	elif heat < 0:
		heat = 0
	emit_signal("heat_updated", heat, heat_capacity, heat_dissipation_rate)
#	print(hea)

func fire_weapons():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		print("firing")
	#	bolt.transform = self.transform
	#	bolt.translation.y = 10
#		bolt.linear_velocity = Vector3()
#		bolt.global_transform = global_transform
		var bolt = pulse_bolt.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(bolt)
		bolt.global_transform = weapon_position.global_transform
		heat += bolt.heat
#		weapon_position.add_child(bolt)

		bolt = pulse_bolt.instance()
		scene_root.add_child(bolt)
		bolt.global_transform = weapon_position_2.global_transform
		heat += bolt.heat

#		bolt = pulse_bolt.instance()
#		weapon_position_2.add_child(bolt)
#
		bolt = pulse_bolt.instance()
		scene_root.add_child(bolt)
		bolt.global_transform = weapon_position_3.global_transform
		heat += bolt.heat

#		bolt = pulse_bolt.instance()
#		weapon_position_3.add_child(bolt)

		bolt = pulse_bolt.instance()
		scene_root.add_child(bolt)
		bolt.global_transform = weapon_position_4.global_transform
		heat += bolt.heat

#		bolt = pulse_bolt.instance()
#		scene_root.add_child(bolt)
#		bolt.global_transform = weapon_position_5.global_transform
#		heat += bolt.heat
#
#		bolt = pulse_bolt.instance()
#		scene_root.add_child(bolt)
#		bolt.global_transform = weapon_position_6.global_transform
#		heat += bolt.heat

#		print(heat)
#
#		bolt = pulse_bolt.instance()
#		weapon_position_4.add_child(bolt)

#Called by physics system every frame, torque/rotation is added here.
func _integrate_forces(state):
	#Only apply torque to our own tank
	if is_network_master():
		state.apply_torque_impulse(turn_torque)

#Fancy function to apply acceleration forces. Makes it so vehicles can't exceed their
# max speed on their own, but can go faster if pushed/thrown somehow.
#Direction: Vector3, desired vector of the push in global coordinates
#D Acceleration: float, How much to add to the speed. Directional acceleration.
#Delta: float, time elapsed on this frame
#Max speed: float, how fast the vehicle can move itself
# Later, we can make this have a fancy acceleration curve
func accelerate(direction, d_acceleration, delta, max_speed):
	#If we're under max speed, calculate new movement force vector to add
	if linear_velocity.length() < max_speed:
		return direction * d_acceleration * delta
	#If we're at max speed, return 0,0,0 to not accelerate any more.
	else:
		return Vector3(0, 0, 0)

func accelerate_forward(direction, d_acceleration, delta, max_speed):
	#If we're under max speed, calculate new movement force vector to add
	if forward_speed < max_speed:
		return direction * d_acceleration * delta
	#If we're at max speed, return 0,0,0 to not accelerate any more.
	else:
		return Vector3(0, 0, 0)

func accelerate_reverse(direction, d_acceleration, delta, max_speed):
	#If we're under max speed, calculate new movement force vector to add
	if reverse_speed < max_speed * -1:
		return direction * d_acceleration * delta
	#If we're at max speed, return 0,0,0 to not accelerate any more.
	else:
		return Vector3(0, 0, 0)

func accelerate_left(direction, d_acceleration, delta, max_speed):
	#If we're under max speed, calculate new movement force vector to add
	if lateral_speed_left < max_speed:
		return direction * d_acceleration * delta
	#If we're at max speed, return 0,0,0 to not accelerate any more.
	else:
		return Vector3(0, 0, 0)

func accelerate_right(direction, d_acceleration, delta, max_speed):
	#If we're under max speed, calculate new movement force vector to add
	if lateral_speed_right < max_speed:
		return direction * d_acceleration * delta
	#If we're at max speed, return 0,0,0 to not accelerate any more.
	else:
		return Vector3(0, 0, 0)

func accelerate_up(direction, d_acceleration, delta, max_speed):
	#If we're under max speed, calculate new movement force vector to add
	if vertspeed_float < max_speed:
		return direction * d_acceleration * delta
	#If we're at max speed, return 0,0,0 to not accelerate any more.
	else:
		return Vector3(0, 0, 0)

func accelerate_down(direction, d_acceleration, delta, max_speed):
	#If we're under max speed, calculate new movement force vector to add
	if vertspeed_float > max_speed * -1:
		return direction * d_acceleration * delta
	#If we're at max speed, return 0,0,0 to not accelerate any more.
	else:
		return Vector3(0, 0, 0)

#Receives mouse movement input moving the camera view. Escape toggles mouselock.
func _input(event):
	#If the passed event was mouse motion, and the mouse is currently captured
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		if Input.is_action_pressed("freelook"):
					#Move the camera gimbal from side to side, clamp to the limited range.
	#		cam_gimbal.rotation_degrees.y = clamp(cam_gimbal.rotation_degrees.y, -30, 30)
	#		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -10, 20)
			var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
			var new_rot_y_2 = cam_gimbal_2.get_rotation_degrees().y + horizontal_rotation
			cam_gimbal_2.set_rotation_degrees(Vector3(0, new_rot_y_2, 0))
			#Move the camera itself up and down, clamp again
			#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
			var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
			var new_rot_x_2 = camera_2.get_rotation_degrees().x + vertical_rotation
			camera_2.set_rotation_degrees(Vector3(new_rot_x_2, 0, 0))

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
			var new_rot_y = cam_gimbal.get_rotation_degrees().y + horizontal_rotation
			cam_gimbal.set_rotation_degrees(Vector3(0, new_rot_y, 0))
			#Move the camera itself up and down, clamp again
			#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
			var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
			var new_rot_x = camera.get_rotation_degrees().x + vertical_rotation
			camera.set_rotation_degrees(Vector3(new_rot_x, -180, 0))

			#Emit update signal to turret. First, assemble the camera's quaternion,
			# relative to the tank base. Slightly messy since it has two rotating parts.
			var cam_quat = Quat(camera.get_transform().basis)
	#		var cam_quat = Quat(Vector3(1, 0, 0), new_rot_x * -0.01)
			var gimbal_quat = Quat(cam_gimbal.get_transform().basis)
			var combined_quat = Quat(Vector3(0, 1, 0), deg2rad(new_rot_y)) * Quat(Vector3(-1, 0, 0), deg2rad(new_rot_x))
	#		var combined_quat = Quat(Vector3(0, 0, 1), PI) * gimbal_quat * cam_quat
			emit_signal("camera_position_updated", cam_quat, gimbal_quat, combined_quat)

func _on_Aimpoint_aimpoint_updated(new_aimpoint):
	weapon_aimpoint = new_aimpoint
	for i in weapon_positions:
		i.look_at(weapon_aimpoint, Vector3(1, 1, 1))

	for i in weapon_mounts:
		i.look_at(weapon_aimpoint, Vector3(1, 1, 1))
#	weapon_position.look_at(weapon_aimpoint, Vector3(0, 0, 1))
#	weapon_position_2.look_at(weapon_aimpoint, Vector3(0, 0, 1))
#	weapon_position_3.look_at(weapon_aimpoint, Vector3(0, 0, 1))
#	weapon_position_4.look_at(weapon_aimpoint, Vector3(0, 0, 1))
#	weapon_positions[1].look_at(weapon_aimpoint, Vector3(0, 0, 1))
#	weapon_position_5.look_at(weapon_aimpoint, Vector3(0, 0, 1))
#	weapon_position_6.look_at(weapon_aimpoint, Vector3(0, 0, 1))