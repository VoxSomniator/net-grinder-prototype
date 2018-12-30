extends RigidBody

var forward_speed
var reverse_speed

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

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

#func accelerate_left(direction, d_acceleration, delta, max_speed):
#	#If we're under max speed, calculate new movement force vector to add
#	if lateral_speed_left < max_speed:
#		return direction * d_acceleration * delta
#	#If we're at max speed, return 0,0,0 to not accelerate any more.
#	else:
#		return Vector3(0, 0, 0)
#
#func accelerate_right(direction, d_acceleration, delta, max_speed):
#	#If we're under max speed, calculate new movement force vector to add
#	if lateral_speed_right < max_speed:
#		return direction * d_acceleration * delta
#	#If we're at max speed, return 0,0,0 to not accelerate any more.
#	else:
#		return Vector3(0, 0, 0)
#
#func accelerate_up(direction, d_acceleration, delta, max_speed):
#	#If we're under max speed, calculate new movement force vector to add
#	if vertspeed_float < max_speed:
#		return direction * d_acceleration * delta
#	#If we're at max speed, return 0,0,0 to not accelerate any more.
#	else:
#		return Vector3(0, 0, 0)