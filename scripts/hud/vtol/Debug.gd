extends Container

var cam_gimbal_quat
var cam_quat
var body_quat
var body_xform_rotation

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	$CamGimbalQuat.text = "cam gimbal quat: " + str(cam_gimbal_quat)
	$CamQuat.text = "cam quat: " + str(cam_quat)
	$BodyQuat.text = "body quat: " + str(body_quat)
	$BodyXformRotation.text = "body xfrom rotation: " + str(body_xform_rotation)

func _on_HUDVTOL_cam_gimbal_quat_updated(received_cam_gimbal_quat):
	cam_gimbal_quat = received_cam_gimbal_quat

func _on_HUDVTOL_cam_quat_updated(received_cam_quat):
	cam_quat = received_cam_quat

func _on_HUDVTOL_body_quat_updated(received_body_quat):
	body_quat = received_body_quat

func _on_HUDVTOL_body_xform_rotation_updated(received_body_xform_rotation):
	body_xform_rotation = received_body_xform_rotation