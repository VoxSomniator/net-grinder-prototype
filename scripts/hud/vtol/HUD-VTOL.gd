extends Control

#Altitude and rotations
signal altitude_updated(altitude)
signal elevation_updated(elevation)

signal body_heading_updated(body_heading)
signal pitch_updated(pitch)
signal roll_updated(roll)

#Speed and throttle
signal speed_kph_float_updated(speed_kph_float)
signal vertspeed_float_updated(vertspeed_float)

signal throttle_updated(throttle)
signal throttle_setting_updated(throttle_setting)

#Quaternion debug
signal cam_gimbal_quat_updated(cam_gimbal_quat)
signal cam_quat_updated(cam_quat)
signal body_quat_updated(body_quat)
signal body_xform_rotation_updated(body_xform_rotation)

signal aimpoint_range_updated(aimpoint_range)
signal aimpoint_unprojected_updated(aimpoint_unprojected)

var speed_kph_float

func _ready():
	pass

#func _process(delta):

func _on_PlayerVTOL_altitude_updated(altitude):
	emit_signal("altitude_updated", altitude)

func _on_PlayerVTOL_elevation_updated(elevation):
	emit_signal("elevation_updated", elevation)

func _on_PlayerVTOL_speed_kph_float_updated(speed_kph_float):
	emit_signal("speed_kph_float_updated", speed_kph_float)

func _on_PlayerVTOL_vertspeed_float_updated(vertspeed_float):
	emit_signal("vertspeed_float_updated", vertspeed_float)

func _on_PlayerVTOL_body_heading_updated(body_heading):
	emit_signal("body_heading_updated", body_heading)

#Throttle signals
func _on_PlayerVTOL_throttle_updated(throttle):
	emit_signal("throttle_updated", throttle)

func _on_PlayerVTOL_throttle_setting_updated(throttle_setting):
	emit_signal("throttle_setting_updated", throttle_setting)

func _on_PlayerVTOL_pitch_updated(pitch):
	emit_signal("pitch_updated", pitch)

func _on_PlayerVTOL_roll_updated(roll):
	emit_signal("roll_updated", roll)

#Quaternion debug signals
func _on_PlayerVTOL_cam_gimbal_quat_updated(cam_gimbal_quat):
	emit_signal("cam_gimbal_quat_updated", cam_gimbal_quat)

func _on_PlayerVTOL_cam_quat_updated(cam_quat):
	emit_signal("cam_quat_updated", cam_quat)

func _on_PlayerVTOL_body_quat_upated(body_quat):
	emit_signal("body_quat_updated", body_quat)

func _on_PlayerVTOL_body_xform_rotation_updated(body_xform_rotation):
	emit_signal("body_xform_rotation_updated", body_xform_rotation)

func _on_Aimpoint_aimpoint_range_updated(aimpoint_range):
	emit_signal("aimpoint_range_updated", aimpoint_range)


func _on_Camera_aimpoint_unprojected_updated(aimpoint_unprojected):
	emit_signal("aimpoint_unprojected_updated", aimpoint_unprojected)
