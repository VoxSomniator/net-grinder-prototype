extends Generic6DOFJoint

const MOUSE_SENSITIVITY = 0.05

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	$Top.rotation_degrees.x = clamp($Top.rotation_degrees.x, -20, 20)
	$Top.rotation_degrees.y = clamp($Top.rotation_degrees.y, -40, 40)

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
		var new_rot_y = $Top.get_rotation_degrees().y + horizontal_rotation
#        $Top.set_rotation_degrees(Vector3(0, new_rot_y, 0))
		var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
		var new_rot_x = $Top.get_rotation_degrees().x + vertical_rotation
		$Top.set_rotation_degrees(Vector3(new_rot_x, new_rot_y, 0))
#        var horizontal_rotation_int = int(horizontal_rotation)
#        self.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY = 3
#        PARAM_ANGULAR_MOTOR_TARGET_VELOCITY.get_param_x()
#        PARAM_LINEAR_LOWER_LIMIT = horizontal_rotation