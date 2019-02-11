extends Spatial

# Input variables

var mouse_sensitivity = 0.0005

# Rotation accumulators
var rot_x = 0
var rot_y = 0

var rot_x_2 = 0
var rot_y_2 = 0

var freelook_rot_x = 0
var freelook_rot_y = 0

# Max rotation ranges
var max_yaw = 40
var max_pitch = 20

var max_yaw_2 = 50
var max_pitch_2 = 30

# Nodes
onready var camera = get_node("Body/CameraHolder/Camera")
onready var camera_holder = get_node("Body/CameraHolder")
onready var look_rotator = get_node("LookRotator")
onready var look_rotator_2 = get_node("LookRotator2")

onready var body = get_node("Body")
onready var look_cube = get_node("LookRotator/LookCube")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	turn_body(delta)
	process_angles(delta)
#	process_input(delta)

func process_input(delta):
	var a = Quat(camera_holder.transform.basis)
#	var b = Quat(camera_root.transform.basis)

#	if !Input.is_action_pressed("freelook"):
#		var c = a.slerp(b, 0.2)
#		camera_holder.transform.basis = Basis(c)

#	var cam_quat = Quat(camera.transform.basis).normalized()
#	var cam_holder_quat = Quat(camera_holder.transform.basis).normalized()
#	var cam_root_quat = Quat(camera_root.transform.basis).normalized()
#	var freelook_zero = cam_holder_quat.slerp(cam_root_quat, 0.2)
#
#	if !Input.is_action_pressed("freelook"):
#		camera_holder.transform.basis = Basis(freelook_zero)
#		camera_holder.transform = camera_holder.transform.orthonormalized()

func turn_body(delta):
#	look_rotator.rotation_degrees.y = clamp(look_rotator.rotation_degrees.y, -20, 20)
#	look_rotator.rotation_degrees.x = clamp(look_rotator.rotation_degrees.x, -20, 20)
#	look_rotator_2.rotation_degrees.y = clamp(look_rotator_2.rotation_degrees.y, -30, 30)
#	look_rotator_2.rotation_degrees.x = clamp(look_rotator_2.rotation_degrees.x, -30, 30)
#	look_cube.look_at(camera.global_transform.origin, Vector3(0, 1, 0))

	# Convert basis to quaternion, keep in mind scale is lost
	var slerp_speed = 0.02
	var slerp_speed_degrees = 10

	var a = Quat(body.transform.basis)
#	var a = Quat(Vector3(0, 1, 0), deg2rad(90))
	var b = Quat(look_rotator.transform.basis)
#	var b = Quat(Vector3(0, 1, 0), deg2rad(90))

	# Interpolate using slerp, rotation speed parameter seems to be in radians per second
	slerp_speed += delta * 2
	var c = a.slerp(b, slerp_speed) # 0.17

	# Apply back
	body.transform.basis = Basis(c)

	if !Input.is_action_pressed("freelook"):
		camera.look_at(look_cube.global_transform.origin, Vector3(0, 1, 0))
		freelook_rot_x = 0
		freelook_rot_y = 0

#	var cam_holder_forward = Quat(camera_holder.transform.basis)
#	var body_forward = Quat(body.transform.basis)
#
#	var body_transform_rotation = Transform(body_forward.slerp(cam_holder_forward, 0.2))
#	body_transform_rotation.origin = body.transform.origin
#	body.transform = body_transform_rotation

func process_angles(delta):
	$CanvasLayer/Angles.text = "Horizontal rotation: " + \
	str(look_rotator.rotation_degrees.y) + "\n" \
	+ "Vertical rotation: " + str(look_rotator.rotation_degrees.x) + "\n" \
	+ "Horizontal rotation 2: " + str(look_rotator_2.rotation_degrees.y) + "\n" \
	+ "Vertical rotation 2: " + str(look_rotator_2.rotation_degrees.x) + "\n" \
	+ "Look cube Z translation: " + str(look_cube.translation.z) + "\n" \
	+ str(rad2deg(Vector2(camera_holder.global_transform.basis.z.x, camera_holder.global_transform.basis.z.z).angle_to(Vector2($MeshInstance.global_transform.origin.x, $MeshInstance.global_transform.origin.z)))) + "\n" \
	+ str(MapState.nav_points)

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		$CanvasLayer/MouseMotion.text = "Relative mouse motion: " + str(event.relative) + "\n" \
		+ "rot_x: " + str(rot_x) + "\n" \
		+ "rot_y: " + str(rot_y) + "\n" \
		+ "rot_x_2: " + str(rot_x_2) + "\n" \
		+ "rot_y_2: " + str(rot_y_2)

		if Input.is_action_pressed("freelook"):
			freelook_rot_x += event.relative.x * mouse_sensitivity * -1
			freelook_rot_y += event.relative.y * mouse_sensitivity
			camera.transform.basis = Basis()

			# First rotate Y, then X to get desired FPS-style rotation
			camera.rotate_object_local(Vector3(0, 1, 0), freelook_rot_x)
			camera.rotate_object_local(Vector3(1, 0, 0), freelook_rot_y)

		else:
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