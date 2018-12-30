extends RigidBody

var max_forward_speed = 20
var max_reverse_speed = -10
var acceleration = 10

var throttle_setting
var throttle

var turn_speed = 60

#Vectors for movement and turning
#var forward_vector = self.global_transform.basis.z.normalized()
var forward_vector = Vector3(0, 0, 1)
var turn_vector = Vector3(0, 0, 0)
var speed_vector = Vector3(0, 0, 0)
var throttle_vector = Vector3(0, 0, 0)
var vel = Vector3()
var dir = Vector3()

func _ready():
	print(forward_vector)
	print(turn_vector)
	throttle_setting = 0
	throttle = 0
#    throttle_setting = clamp(throttle_setting, max_reverse_speed, max_forward_speed)

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_hud(delta)

func process_input(delta):
	#Throttle stuff
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

	if throttle_setting > 0:
		input_movement_vector.y += 1
	if throttle_setting < 0:
		input_movement_vector.y -= 1

	input_movement_vector = input_movement_vector.normalized()

	dir += forward_vector * input_movement_vector.y

	#Turn stuff
	turn_vector.y = 0
	angular_velocity.y = clamp(turn_vector.y, turn_speed * -1, turn_speed)
	if Input.is_action_pressed("movement_left"):
		turn_vector.y = turn_speed
#	else:
#		turn_vector.y = 0
	if Input.is_action_pressed("movement_right"):
		turn_vector.y = turn_speed * -1
#	else:
#		turn_vector.y = 0

func process_movement(delta):
	dir = dir.normalized()

	var target = dir
	target *= throttle_setting

	vel = vel.linear_interpolate(target, acceleration * delta)

	speed_vector.z = 1
	speed_vector *= throttle_setting
	throttle_vector = forward_vector.linear_interpolate(speed_vector, acceleration * delta)
	throttle = linear_velocity.z
#	print(forward_vector)

func process_hud(delta):
	$HUD/Throttle.text = "Max forward speed: " + str(max_forward_speed) + "\n" \
	+ "Max reverse speed: " + str(max_reverse_speed) + "\n" \
	+ "Throttle setting: " + str(throttle_setting) + "\n" \
	+ "Throttle: " + str(throttle)

func _integrate_forces(state):
	if turn_vector.y != 0:
		add_torque(turn_vector)
	add_central_force(vel)