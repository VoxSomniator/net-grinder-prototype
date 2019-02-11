extends KinematicBody

var gravity : float = -24.8
var max_forward_speed : float = 46.6
var max_reverse_speed : float = -20
var acceleration : float = 1.5
var deceleration : float = 1.5
var accel : float = 0
var accel_zoned : float = 0

var vel = Vector3()
var dir = Vector3()

var leg_turn_speed = 1
var transverse_speed = 0.05

var max_slope_angle = 45

var max_yaw = 90
var max_pitch = 30
var max_yaw_2 = 120
var max_pitch_2 = 45

var throttle_setting = 0
var throttle_setting_percentage = 0
var ground_speed = 0

# Weapons / aim
onready var torso_aim = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/TorsoAim")
var torso_aimpoint = Vector3()
var torso_aim_distance = 0

onready var arm_mount_left = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/arm-mount-left")
onready var arm_mount_right = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/arm-mount-right")

onready var weapon_group_1 = [
get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/arm-mount-left/arm-weapon-upper/TestMechLaser"),
get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/arm-mount-right/arm-weapon-upper/TestMechLaser"),
]

onready var weapon_group_2 = [
get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/arm-mount-left/arm-weapon-lower/Machinegun"),
get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/arm-mount-right/arm-weapon-lower/Machinegun")
]

onready var arm_aim = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/ArmRayRotator/ArmAim")
var arm_aimpoint = Vector3()
var arm_aim_distance = 0

# Rotation accumulators
var rot_x = 0
var rot_y = 0

var rot_x_2 = 0
var rot_y_2 = 0

var mouse_sensitivity = 0.0005

var turn_speed = 0.17

# Body/rotator nodes
onready var upper_body = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/body-upper")
onready var cockpit = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/cockpit-x/cockpit-rotator/cockpit")
onready var upper_body_rotator = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x")
onready var cockpit_rotator = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/cockpit-x/cockpit-rotator")
onready var arm_ray_rotator = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/ArmRayRotator")

# Look/aim nodes
onready var look_rotator = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/TorsoPointer")
onready var look_rotator_2 = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/ArmPointer")
onready var look_point = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/TorsoPointer/LookPoint")

onready var camera = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/Camera")

# Navigation
#export(NodePath) var active_navpoint

# Called when the node enters the scene tree for the first time.
func _ready():
	upper_body.hide()
	cockpit.show()

	VehicleState.max_torso_pitch = max_pitch
	VehicleState.max_torso_yaw = max_yaw

	VehicleState.body = get_node("Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x")

	VehicleState.max_forward_speed = max_forward_speed
	VehicleState.max_reverse_speed = max_reverse_speed

	VehicleState.camera = camera

	VehicleState.arm_aim = arm_aim

#	VehicleState.active_navpoint = active_navpoint
#	print(active_navpoint)

#	VehicleState.body = self
#	global_transform.origin.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	turn_body(delta)
	process_input(delta)
	process_movement(delta)
	process_weapons(delta)
	process_angles(delta)

func turn_body(delta):
	var a = Quat(upper_body_rotator.transform.basis)
	var b = Quat(cockpit_rotator.transform.basis)
	var c = Quat(look_rotator.transform.basis)
	var f = Quat(arm_ray_rotator.transform.basis)
	var g = Quat(look_rotator_2.transform.basis)

	var d = a.slerp(c, turn_speed)
	var e = b.slerp(c, turn_speed)
	var h = f.slerp(g, turn_speed)

	upper_body_rotator.transform.basis = Basis(d)
	cockpit_rotator.transform.basis = Basis(e)
	arm_ray_rotator.transform.basis = Basis(h)

	camera.look_at(look_point.global_transform.origin, Vector3(0, 1, 0))

func process_input(delta):
	#Throttle stuff
	var mech_xform = self.global_transform
	dir = Vector3()
	var input_movement_vector = Vector2()

	throttle_setting = clamp(throttle_setting, max_reverse_speed, max_forward_speed)
	if Input.is_action_pressed("movement_forward"):
		if throttle_setting >= 0:
			throttle_setting += (max_forward_speed * 0.01)
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

	VehicleState.throttle_setting = throttle_setting

	input_movement_vector = input_movement_vector.normalized()

	dir += mech_xform.basis.z.normalized() * input_movement_vector.y

	#Turn stuff
	if Input.is_action_pressed("movement_left"):
		rotate_y(deg2rad(leg_turn_speed))
	if Input.is_action_pressed("movement_right"):
		rotate_y(deg2rad(leg_turn_speed * -1))

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * gravity

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= throttle_setting

	var forward_vector = self.global_transform.basis.z.normalized()
	ground_speed = forward_vector.dot(hvel)

	VehicleState.ground_speed = ground_speed

	$AnimationTree.set("parameters/Blend2/blend_amount", ground_speed / max_forward_speed)
	$AnimationTree.set("parameters/TimeScale/scale", 0.5 + ((ground_speed / max_forward_speed) * 0.5) )

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

	if throttle_setting == 0:
		accel = deceleration

	if throttle_setting_percentage < 10:
		if ground_speed == 0:
			accel_zoned = 0
	else:
		accel_zoned = accel

	hvel = hvel.linear_interpolate(target, acceleration * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(max_slope_angle))

func process_weapons(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
	#	if torso_aim.is_colliding():
	#		torso_aimpoint = torso_aim.get_collision_point()
	#	else:
		torso_aimpoint = $"Skeleton/BoneAttachment/Spatial/body-upper-y/body-upper-x/TorsoAim/Endpoint".global_transform.origin

	#	if arm_aim.is_colliding():
	#		arm_aimpoint = arm_aim.get_collision_point()
	#	else:
		arm_aimpoint = $"Skeleton/BoneAttachment/Spatial/body-upper-y/ArmRayRotator/ArmAim/Endpoint".global_transform.origin
		arm_aim_distance = arm_aim.get_collision_point().distance_to(arm_aim.global_transform.origin)

		VehicleState.torso_aimpoint_2d = camera.unproject_position(torso_aimpoint)
		VehicleState.arm_aimpoint_2d = camera.unproject_position(arm_aimpoint)

		VehicleState.arm_aim_distance = arm_aim_distance

		arm_mount_left.look_at(arm_aimpoint, Vector3(0, 1, 0))
		arm_mount_right.look_at(arm_aimpoint, Vector3(0, 1, 0))


#		for w in weapon_group_1:
#			w.look_at(arm_aimpoint, Vector3(0, 1, 0))

		if Input.is_action_pressed("fire_selected_weapon"):
			for w in weapon_group_1:
				w.fire()

		if Input.is_action_pressed("fire_weapon_2"):
			for w in weapon_group_2:
				w.fire()

func process_angles(delta):
	var torso_heading = rad2deg(Vector2(upper_body_rotator.global_transform.basis.z.x, upper_body_rotator.global_transform.basis.z.z).angle_to(Vector2(0,1)))
	if torso_heading < 0:
		torso_heading += 360 # Beautify heading, remove negative angle
	VehicleState.torso_heading = torso_heading * -1 + 360

	VehicleState.torso_pitch = upper_body_rotator.rotation_degrees.x
	VehicleState.torso_yaw = upper_body_rotator.rotation_degrees.y
	VehicleState.body_pos = Vector2(upper_body_rotator.global_transform.basis.z.x, upper_body_rotator.global_transform.basis.z.z)

func navpoint_reached():
	pass

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
					# Yaw
			if event.relative.x < 0 && look_rotator.rotation_degrees.y < max_yaw:
				if look_rotator_2.rotation_degrees.y >= max_yaw * -1:
					rot_x += event.relative.x * mouse_sensitivity * -1
			elif event.relative.x > 0 && look_rotator.rotation_degrees.y > max_yaw * -1:
				if look_rotator_2.rotation_degrees.y <= max_yaw:
					rot_x += event.relative.x * mouse_sensitivity * -1

			if event.relative.x < 0 && look_rotator_2.rotation_degrees.y < max_yaw_2:
				rot_x_2 += event.relative.x * mouse_sensitivity * -1
			elif event.relative.x > 0 && look_rotator_2.rotation_degrees.y > max_yaw_2 * -1:
				rot_x_2 += event.relative.x * mouse_sensitivity * -1

			# Pitch
			if event.relative.y < 0 && look_rotator.rotation_degrees.x > max_pitch * -1:
				if look_rotator_2.rotation_degrees.x <= max_pitch:
					rot_y += event.relative.y * mouse_sensitivity
			elif event.relative.y > 0 && look_rotator.rotation_degrees.x < max_pitch:
				if look_rotator_2.rotation_degrees.x >= max_pitch * -1:
					rot_y += event.relative.y * mouse_sensitivity

			if event.relative.y < 0 && look_rotator_2.rotation_degrees.x > max_pitch_2 * -1:
				rot_y_2 += event.relative.y * mouse_sensitivity
			elif event.relative.y > 0 && look_rotator_2.rotation_degrees.x < max_pitch_2:
				rot_y_2 += event.relative.y * mouse_sensitivity

#			rot_y += event.relative.y * mouse_sensitivity
			look_rotator.transform.basis = Basis()

			# First rotate Y, then X to get desired FPS-style rotation
			look_rotator.rotate_object_local(Vector3(0, 1, 0), rot_x)
			look_rotator.rotate_object_local(Vector3(1, 0, 0), rot_y)
			look_rotator.rotation_degrees.y = clamp(look_rotator.rotation_degrees.y, max_yaw * -1, max_yaw)
			look_rotator.rotation_degrees.x = clamp(look_rotator.rotation_degrees.x, max_pitch * -1, max_pitch)

#			if look_rotator.rotation_degrees.y >= 20:
			look_rotator_2.transform.basis = Basis()
			look_rotator_2.rotate_object_local(Vector3(0, 1, 0), rot_x_2)
			look_rotator_2.rotate_object_local(Vector3(1, 0, 0), rot_y_2)
			look_rotator_2.rotation_degrees.y = clamp(look_rotator_2.rotation_degrees.y, max_yaw_2 * -1, max_yaw_2)
			look_rotator_2.rotation_degrees.x = clamp(look_rotator_2.rotation_degrees.x, max_pitch_2 * -1, max_pitch_2)

#		rot_x += event.relative.x * mouse_sensitivity
#		rot_y += event.relative.y * mouse_sensitivity
#		look_rotator.transform.basis = Basis()

		# First rotate Y, then X to get desired FPS-style rotation
#		look_rotator.rotate_object_local(Vector3(0, 1, 0), rot_x)
#		look_rotator.rotate_object_local(Vector3(1, 0, 0), rot_y)