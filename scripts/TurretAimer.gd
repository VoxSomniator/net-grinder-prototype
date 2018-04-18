extends Skeleton

#Constants for different axes
var y_vec = Vector3(0, 1, 0)
var x_vec = Vector3(1, 0, 0)

#Which bone to move for the turret
var turret_bone
#Transverse is horizontal, elevation is vertical
var transverse_speed = 0.05
var elevation_speed
#Range of -1 means the turret can turn forever in that axis,
# like the transverse of most tanks
var transverse_range = -1
var elevation_max = 45
var elevation_min = -10

#Quats for the facings of the various camera parts, relative to tank base.
var cam_quat = Quat(get_transform().basis)
var cam_gimbal_quat = Quat(get_transform().basis)
#Current aim for other scripts to access
var y_rotation = 0
var x_rotation = 0

func _ready():
	turret_bone = find_bone("tank-turret")

func _process(delta):
	#Copies the current turret transform into turret_transform
	var turret_transform = get_bone_pose(turret_bone)
	#Gets turret's current rotations
	y_rotation = turret_transform.basis.get_euler().y
	x_rotation = turret_transform.basis.get_euler().x
	
	#Quaternion copy of the current turret transform
	var gun_quat = Quat(turret_transform.basis).normalized()
	#Quaternion representing the desired facing
	#FUSION? lol it should neatly slide or something
	var turret_transform_rotation = Transform(gun_quat.slerp(cam_gimbal_quat, transverse_speed))
	
	#Make sure the new transform has the right origin
	turret_transform_rotation.origin = turret_transform.origin
	#Replace it
	turret_transform = turret_transform_rotation
	
	set_bone_pose(turret_bone, turret_transform)
	

#Updates the position of the camera to target
func _on_Player_camera_position_updated(new_cam, new_gimbal):
	cam_quat = new_cam
	cam_gimbal_quat = new_gimbal

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