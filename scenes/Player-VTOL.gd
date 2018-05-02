extends RigidBody

#A player-controlled tank.
#Currently, moves around, controlled by master player or signals from other masters.
#Uses rigidbody instead of kinematicbody, because big bulky vehicles should have physics.
#Kinematicbody lacks the inertia and rotation and everything.

#Emitted when this tank becomes the active player, makes its camera current.
#Used instead of a direct path call so the camera can be rearranged safely.
signal camera_activated()
#Holds ref to the camera gimbal object
var cam_gimbal
#holds ref to the camera object
var camera
#Holds a ref to the turret skeleton thing. Used by camera.
var skeleton
#How fast the mouse moves the camera
const MOUSE_SENSITIVITY = 0.05
#Maximum rotation angles of the camera
const CAM_Y_RANGE = 45
const CAM_X_RANGE = 45
#Signal emitted by camera to update turret's position
signal camera_position_updated(cam_quat, gimbal_quat)


#Body heading signal
signal body_heading_updated(body_heading)

#Body global transform and heading variables
var body_xform
var body_heading
var body_quat
var body_xform_rotation

signal altitude_updated(altitude)
signal elevation_updated(elevation)

var altitude
var elevation

var cam_quat
var cam_gimbal_quat


#HOW FAST can we go (forward/backward)
var max_forward_speed = 40
#How fast do we get going
var acceleration = 1000
#Vector used for normal driving direction.
#Rigidbodies use world rotation, so this changes as the tank turns.
#By default it's set to upwards, so problems will be OBVIOUS
var forward_vector = Vector3(0, 1, 0)
#Used to total forces/accelerations and apply every frame. Still world coordinates.
var moving_vector = Vector3(0, 0, 0)

var lateral_vector = Vector3(1, moving_vector.y, 0)
var max_lateral_speed = 40

#How fast do we spin?
var turn_speed = 0.2
#Used to store rotation torque for physics processing
var turn_torque = Vector3(0, 0, 0)

var roll_speed = 0.02
#var roll_torque = Vector3(0, 0, 0)
var roll_torque =  get_transform().basis.z

var transverse_speed = 0.05

signal throttle_updated(throttle)
signal throttle_setting_updated(throttle_setting)

var throttle
var max_throttle = 40
var max_throttle_reverse = max_throttle * -0.5
var throttle_setting

signal vertspeed_float_updated(vertspeed_float)
var max_vertical_thrust =  20
var vertical_acceleration = 1000
var vertspeed_float
var vertical_thrust_vector = Vector3(0, 1, 0)

signal speed_kph_float_updated(speed_kph_float)
var speed_kph_float

#Used only by instances of other players' tanks. Each player's master tank updates all the other slaves.
slave var other_transform

var start_jump = false
var max_jump_speed = 100
var in_freefall_up = false
var in_freefall_down = false
var in_freefall = false
var can_jump = true

func _ready():
	#If this vehicle is the local player's, do some stuff
	if is_network_master():
		#Turn on its camera, which turns off the old one probably
		emit_signal("camera_activated")
		#Set up other camera stuff- Only in this section, otherwise, every other
		# player's tank would do this too and that might get wonky
		cam_gimbal = $"Camera-gimbal"
		camera = $"Camera-gimbal/Camera"
		skeleton = $"vtol-model/Armature/Skeleton"
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		set_process_input(true)
		throttle = 0
		throttle_setting = 0
#		gravity_scale = 0

func _process(delta):
	
	#If this is the locally-controlled tank, get inputs to move
	if is_network_master():
		#Set our forward vector properly
		forward_vector = global_transform.basis.z.normalized()
		#Reset the "current forces" vector
		moving_vector = Vector3(0, 0, 0)
		#Resets "torque" vector
		turn_torque = Vector3(0, 0, 0)
		#Resets roll torque
#		roll_torque = Vector3(0, 0, 0)
		roll_torque =  get_transform().basis.z
		
#		self.rotation_degrees.z = 0
		
		
		#Drive forward, up to max speed
#		if Input.is_action_pressed("movement_forward"):
#			moving_vector = accelerate(forward_vector, acceleration, delta, max_forward_speed)
#		elif Input.is_action_pressed("movement_backward"):
#			moving_vector = accelerate(forward_vector, -1 * acceleration, delta, max_forward_speed)
		
		#Move via throttle
		if Input.is_action_pressed("movement_forward"):
			if throttle_setting < max_throttle:
				throttle_setting += max_throttle * 0.01
		elif Input.is_action_pressed("movement_backward"):
			if throttle_setting > max_throttle_reverse:
				throttle_setting -= max_throttle * 0.01
		
		#Keep throttle within maximum values
		if throttle_setting > max_throttle:
			throttle_setting = max_throttle
		elif throttle_setting < max_throttle_reverse:
			throttle_setting = max_throttle_reverse
		
		if Input.is_action_pressed("movement_left"):
			moving_vector += accelerate(body_xform.basis.x.normalized(), acceleration, delta, max_lateral_speed)
		elif Input.is_action_pressed("movement_right"):
			moving_vector += accelerate(body_xform.basis.x.normalized() * -1, acceleration, delta, max_lateral_speed)
	
		#Turn left/right
		if Input.is_action_pressed("ui_left"):
			turn_torque.y += turn_speed
		if Input.is_action_pressed("ui_right"):
			turn_torque.y -= turn_speed
		
		#Roll left/right
		if Input.is_action_pressed("vtol_roll_left"):
			roll_torque.z -= roll_speed
		if Input.is_action_pressed("vtol_roll_right"):
			roll_torque.z += roll_speed
		
		#Throttle
		if throttle < throttle_setting:
			throttle += acceleration
		elif throttle > throttle_setting:
			throttle -= acceleration
		
		moving_vector = accelerate(forward_vector, acceleration, delta, throttle_setting)
		emit_signal("throttle_updated", throttle)
		emit_signal("throttle_setting_updated", throttle_setting)
		
#		if Input.is_key_pressed(KEY_SPACE) && can_jump:
#			#Sets a limit on how high the tank can jump
#			if linear_velocity.y < max_jump_speed:
#				#If the tank has stopped accelerating upwards in the current jump, 
#				#it cannot start accelerating upwards again.
#				if !in_freefall:
#					moving_vector = moving_vector + Vector3(0,100,0)
#					start_jump = true
#			#The tank is in the middle of jumping, but has reached its 
#			#top upwards speed
#			elif start_jump:
#				start_jump = false
#				in_freefall_up = true
#				in_freefall = true
#		#The tank had started jumping, but the user ended the jump
#		elif start_jump:
#			start_jump = false
#			in_freefall_up = true
#			in_freefall = true
#		#The tank has reached the apex of its jump
#		if in_freefall_up && linear_velocity.y < -0.01:
#			in_freefall_up = false
#			in_freefall_down = true
#		#The tank has landed and can jump again
#		if in_freefall_down && linear_velocity.y > -0.01:
#			in_freefall = false
#			in_freefall_down = false
		
#		if elevation > 1:
		moving_vector += accelerate(vertical_thrust_vector, 490, delta, 490)
		
		if Input.is_action_pressed("vtol_ascend"):
			moving_vector += accelerate(vertical_thrust_vector, vertical_acceleration, delta, max_vertical_thrust)
		
		if Input.is_action_pressed("vtol_descend"):
			moving_vector += accelerate(vertical_thrust_vector, -1 * vertical_acceleration, delta, max_vertical_thrust)
		
		speed_kph_float = get_transform().basis.xform_inv(get_linear_velocity()).z * 3.6
		emit_signal("speed_kph_float_updated", speed_kph_float)
		
		vertspeed_float = get_transform().basis.xform_inv(get_linear_velocity()).y
		emit_signal("vertspeed_float_updated", vertspeed_float)
		
		#After all forces are calculated, apply the impulse.
		apply_impulse(Vector3(0, 0, 0), moving_vector*delta)
	
		#Send our tank's new coordinates to all the other games
		rset_unreliable("other_transform", global_transform)
		
		#Listen for esc keypress, toggle mouse lock/look
		if Input.is_action_just_pressed("ui_cancel"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		#Altitude and elevation
		altitude = $GroundDetector.global_transform.origin.y
		elevation = $GroundDetector.get_collision_normal().distance_to(Vector3(0, $GroundDetector.global_transform.origin.y, 0))
		emit_signal("altitude_updated", altitude)
		emit_signal("elevation_updated", elevation)
		
		#Body global transform and heading values
		body_xform = self.get_global_transform()
		body_heading = rad2deg(Vector2(body_xform.basis.z.x, body_xform.basis.z.z).angle_to(Vector2(0,1)))
		if body_heading < 0:
			body_heading += 360 # beautify heading, remove negative angle
		emit_signal("body_heading_updated", body_heading)
		
		cam_quat = Quat(camera.get_transform().basis)
		cam_gimbal_quat = Quat(cam_gimbal.get_transform().basis)
		
		body_quat = Quat(body_xform.basis).normalized()
		
		body_xform_rotation = Transform(body_quat.slerp(cam_gimbal_quat, transverse_speed))
		
		#Make sure the new transform has the right origin
		body_xform_rotation.origin = body_xform.origin
		#Replace it
		body_xform = body_xform_rotation
	
	else:
		#If this is the slave tank to another player
		global_transform = other_transform

#Called by physics system every frame, torque/rotation is added here.
func _integrate_forces(state):
	#Only apply torque to our own tank
	if is_network_master():
		state.apply_torque_impulse(turn_torque)
#		state.apply_torque_impulse(roll_torque)

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
	

#Receives mouse movement input moving the camera view. Escape toggles mouselock.
func _input(event):
	#If the passed event was mouse motion, and the mouse is currently captured
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		
		#Move the camera gimbal from side to side, clamp to the limited range.
		var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
		var new_rot_y = cam_gimbal.get_rotation_degrees().y + horizontal_rotation
#		cam_gimbal.set_rotation_degrees(Vector3(0, new_rot_y, 0))
		#Move the camera itself up and down, clamp again
		#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
		var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
		var new_rot_x = camera.get_rotation_degrees().x + vertical_rotation
#		camera.set_rotation_degrees(Vector3(new_rot_x, -180, 0))
		self.rotate_x(deg2rad(new_rot_x * MOUSE_SENSITIVITY * -10))
		self.rotate_y(deg2rad(new_rot_y * MOUSE_SENSITIVITY * 10))
		
		
		#Emit update signal to turret. First, assemble the camera's quaternion,
		# relative to the tank base. Slightly messy since it has two rotating parts.
#		emit_signal("camera_position_updated", cam_quat, gimbal_quat)
		
		