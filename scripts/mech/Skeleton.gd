extends Skeleton

#Signal passing turret transform data for the raycast
signal turret_transform_updated(turret_transform)

#Constants for different axes
var y_vec = Vector3(0, 1, 0)
var x_vec = Vector3(1, 0, 0)

#Which bone to move for the turret
var turret_bone

#Body, cockpit and canopy meshes
var body_mesh
var cockpit_mesh
var canopy_mesh

#Transverse is horizontal, elevation is vertical
var transverse_speed = 0.09
var elevation_speed
#Range of -1 means the turret can turn forever in that axis,
# like the transverse of most tanks
var transverse_range
var elevation_max
var elevation_min

var body_pitch
signal body_pitch_updated(body_pitch)


#Quats for the facings of the various camera parts, relative to tank base.
var cam_quat = Quat(get_transform().basis)
var cam_gimbal_quat = Quat(get_transform().basis)
var combined_quat = Quat(get_transform().basis)
var combined_quat_2
#Current aim for other scripts to access
var y_rotation = 0
var x_rotation = 0

func _ready():
	turret_bone = find_bone("body")
#	turret_bone = $cockpit
	body_mesh = $"body-upper"
	cockpit_mesh = $cockpit
	canopy_mesh = $canopy

func _physics_process(delta):
	#Copies the current turret transform into turret_transform
#	combined_quat = cam_gimbal_quat * cam_quat
	combined_quat_2 = cam_gimbal_quat * cam_quat
	var turret_transform = get_bone_pose(turret_bone)
#	var turret_transform = turret_bone.transform
	var body_mesh_transform = body_mesh.transform
	var cockpit_mesh_transform = cockpit_mesh.transform
	var canopy_mesh_transform = canopy_mesh.transform
	#Gets turret's current rotations
	y_rotation = turret_transform.basis.get_euler().y
	x_rotation = turret_transform.basis.get_euler().x
	
	
	#Quaternion copy of the current turret transform
	var gun_quat = Quat(turret_transform.basis).normalized()
	
	var body_mesh_quat = Quat(body_mesh_transform.basis).normalized()
	var cockpit_mesh_quat = Quat(cockpit_mesh_transform.basis).normalized()
	var canopy_mesh_quat = Quat(canopy_mesh_transform.basis).normalized()
	#Quaternion representing the desired facing
	#FUSION? lol it should neatly slide or something
	var turret_transform_rotation = Transform(gun_quat.slerp(combined_quat, transverse_speed))
	
	var body_mesh_transform_rotation = Transform(body_mesh_quat.slerp(combined_quat, transverse_speed))
	var cockpit_mesh_transform_rotation = Transform(cockpit_mesh_quat.slerp(combined_quat, transverse_speed))
	var canopy_mesh_transform_rotation = Transform(canopy_mesh_quat.slerp(combined_quat, transverse_speed))
	
	#Make sure the new transform has the right origin
	turret_transform_rotation.origin = turret_transform.origin
	
	body_mesh_transform_rotation.origin = body_mesh_transform.origin
	cockpit_mesh_transform_rotation.origin = cockpit_mesh_transform.origin
	canopy_mesh_transform_rotation.origin = canopy_mesh_transform.origin
	#Replace it
	turret_transform = turret_transform_rotation
	
	body_mesh_transform = body_mesh_transform_rotation
	cockpit_mesh_transform = cockpit_mesh_transform_rotation
	canopy_mesh_transform = canopy_mesh_transform_rotation
	
	set_bone_pose(turret_bone, turret_transform)
#	turret_bone.transform = turret_transform
	
	body_mesh.transform = body_mesh_transform
	cockpit_mesh.transform = cockpit_mesh_transform
	canopy_mesh.transform = canopy_mesh_transform
	
	body_mesh.rotation_degrees.y = clamp(body_mesh.rotation_degrees.y, transverse_range * -1, transverse_range)
	cockpit_mesh.rotation_degrees.y = clamp(cockpit_mesh.rotation_degrees.y, transverse_range * -1, transverse_range)
	canopy_mesh.rotation_degrees.y = clamp(canopy_mesh.rotation_degrees.y, transverse_range * -1, transverse_range)
	
	body_mesh.rotation_degrees.x = clamp(body_mesh.rotation_degrees.x, elevation_max * -1, elevation_min * -1)
	cockpit_mesh.rotation_degrees.x = clamp(cockpit_mesh.rotation_degrees.x, elevation_max * -1, elevation_min * -1)
	canopy_mesh.rotation_degrees.x = clamp(canopy_mesh.rotation_degrees.x, elevation_max * -1, elevation_min * -1)
	
	body_pitch = body_mesh.rotation_degrees.x
	emit_signal("body_pitch_updated", body_pitch)
	
#	body_mesh.rotation.x *= -1
#	cockpit_mesh.rotation.x *= -1
#	canopy_mesh.rotation.x *= -1
	
	emit_signal("turret_transform_updated", turret_transform)
	
	

#Updates the position of the camera to target
#func _on_Player_camera_position_updated(new_cam, new_gimbal, new_combined):
#	cam_quat = new_cam
#	cam_gimbal_quat = new_gimbal
#	combined_quat = new_combined

#Getter functions, to access the turret's rotations. Returns radians.
func get_y_rotation():
	return y_rotation
func get_x_rotation():
	return x_rotation
#Other ones that return degrees.
func get_y_degrees():
	return rad2deg(y_rotation)
func get_x_degrees():
	return rad2deg(x_rotation)

func _on_PlayerMechHeavy_camera_position_updated(new_cam, new_gimbal, new_combined):
	cam_quat = new_cam
	cam_gimbal_quat = new_gimbal
	combined_quat = new_combined
#	print(combined_quat)

func _on_PlayerMechHeavy_max_rotation_ranges(max_yaw, max_pitch_down, max_pitch_up):
	transverse_range = max_yaw
	elevation_min = max_pitch_down
	elevation_max = max_pitch_up
	print("signal")