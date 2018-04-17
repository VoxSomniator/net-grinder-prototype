extends RigidBody

enum TurnDirection {
	left,
	right,
	forward
}

#A player-controlled tank.
#Currently, moves around, controlled by master player or signals from other masters.
#Uses rigidbody instead of kinematicbody, because big bulky vehicles should have physics.
#Kinematicbody lacks the inertia and rotation and everything.


#HOW FAST can we go (forward/backward)
var max_forward_speed = 100
#How fast do we get going
var acceleration = 2000
#Vector used for normal driving direction.
#Rigidbodies use world rotation, so this changes as the tank turns.
#By default it's set to upwards, so problems will be OBVIOUS
var forward_vector = Vector3(0, 1, 0)
#Used to total forces/accelerations and apply every frame. Still world coordinates.
var moving_vector = Vector3(0, 0, 0)

#How fast do we spin?
var turn_speed = 3
#Used to store rotation torque for physics processing
var turn_torque = Vector3(0, 0, 0)

#Used only by instances of other players' tanks. Each player's master tank updates all the other slaves.
slave var other_transform

var start_jump = false
var max_jump_speed = 20
var in_freefall_up = false
var in_freefall_down = false
var in_freefall = false
var can_jump = true
var turn_direction = TurnDirection.forward



func _ready():
	#If this vehicle is the local player's, do some stuff
	if is_network_master():
		#Turn on its camera, which turns off the old one probably
		$Camera.make_current()

func _process(delta):
	
	#If this is the locally-controlled tank, get inputs to move
	if is_network_master():
		#Set our forward vector properly
		forward_vector = global_transform.basis.z.normalized()
		#Reset the "current forces" vector
		moving_vector = Vector3(0, 0, 0)
		#Resets "torque" vector
		turn_torque = Vector3(0, 0, 0)
		#Drive forward, up to max speed
		if Input.is_action_pressed("ui_up"):
			moving_vector = accelerate(forward_vector, acceleration, delta, max_forward_speed)	
		elif Input.is_action_pressed("ui_down"):
			moving_vector = accelerate(forward_vector, -1 * acceleration, delta, max_forward_speed)	
			
		#Turn left/right
		if Input.is_action_pressed("ui_left"):
			#turn_torque.y += turn_speed
				angular_velocity.y = turn_speed;
		elif Input.is_action_pressed("ui_right"):
			#turn_torque.y -= turn_speed
				angular_velocity.y = -turn_speed;
		else:
				angular_velocity.y = 0
		if Input.is_key_pressed(KEY_SPACE) && can_jump:
			#Sets a limit on how high the tank can jump
			if linear_velocity.y < max_jump_speed:
				#If the tank has stopped accelerating upwards in the current jump, 
				#it cannot start accelerating upwards again.
				if !in_freefall:
					moving_vector = moving_vector + Vector3(0,100,0)
					start_jump = true
			#The tank is in the middle of jumping, but has reached its 
			#top upwards speed
			elif start_jump:
				start_jump = false
				in_freefall_up = true
				in_freefall = true
		#The tank had started jumping, but the user ended the jump
		elif start_jump:
			start_jump = false
			in_freefall_up = true
			in_freefall = true
		#The tank has reached the apex of its jump
		if in_freefall_up && linear_velocity.y < -0.01:
			in_freefall_up = false
			in_freefall_down = true
		#The tank has landed and can jump again
		if in_freefall_down && linear_velocity.y > -0.01:
			in_freefall = false
			in_freefall_down = false
		
		#After all forces are calculated, apply the impulse.
		apply_impulse(Vector3(0, 0, 0), moving_vector*delta)
	
		#Send our tank's new coordinates to all the other games
		rset_unreliable("other_transform", global_transform)
	
	else:
		#If this is the slave tank to another player
		global_transform = other_transform

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
	
		
	