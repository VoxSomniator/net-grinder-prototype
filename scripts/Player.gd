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
var bullet

var bullet_timer
#The amount of seconds it takes to fire a bullet
var fire_rate = .5
var bullet_speed = 75
var can_fire = true
onready var UtilityQuat = preload("res://scripts/UtilityQuat.gd")



func _ready():
	#If this vehicle is the local player's, do some stuff
	if is_network_master():
		#Turn on its camera, which turns off the old one probably
		emit_signal("camera_activated")
		#Set up other camera stuff- Only in this section, otherwise, every other
		# player's tank would do this too and that might get wonky
		cam_gimbal = $"Camera-gimbal"
		camera = $"Camera-gimbal/Camera"
		skeleton = $"Scene Root2/tank-armature/Skeleton"
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		set_process_input(true)
		bullet = preload("res://scenes/Bullet.tscn")
		bullet_timer = Timer.new()
		bullet_timer.wait_time = fire_rate
		bullet_timer.one_shot = true
		bullet_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
		bullet_timer.connect("timeout",self,"_enable_fire")
		add_child(bullet_timer)
		
func _enable_fire():
	can_fire = true

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
		if Input.is_key_pressed(KEY_K):
			if can_fire:
				var turret_rotation = $TurretAimPoint.get_rotation()
				var tank_rotation = self.get_rotation()
				var turret_quat = UtilityQuat.quat_from_YXZ(turret_rotation)
				var tank_quat = UtilityQuat.quat_from_YXZ(tank_rotation)
				var combined_quat = tank_quat.add_rotation(turret_quat)
				can_fire = false
				var b = bullet.instance()
				#b.transform = self.transform
				b.transform = $TurretAimPoint.get_transform()
				#var translate_rotator = UtilityQuat.quat_from_YXZ(Vector3(0, self.get_rotation().y, 0))
				var translate_rotator = combined_quat
				b.linear_velocity = translate_rotator.rotate(Vector3(0, 0, bullet_speed))
				var test_velocity = b.linear_velocity
				self.get_parent().add_child(b)
				var offset_vector = Vector3(0,2,10)
				offset_vector = tank_quat.rotate(offset_vector)
				b.translate(offset_vector)
				var self_position = self.to_global(Vector3(0,0,0))
				var turret_corrector = turret_quat.reciprocal()
				var corrected_self_position = turret_corrector.rotate(self_position)
				b.translate(corrected_self_position)
				bullet_timer.start()
		
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
		
		#Body global transform and heading values
		body_xform = self.get_global_transform()
		body_heading = rad2deg(Vector2(body_xform.basis.z.x, body_xform.basis.z.z).angle_to(Vector2(0,1)))
		if body_heading < 0:
			body_heading += 360 # beautify heading, remove negative angle
		emit_signal("body_heading_updated", body_heading)
	
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
	

#Receives mouse movement input moving the camera view. Escape toggles mouselock.
func _input(event):
	#If the passed event was mouse motion, and the mouse is currently captured
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		
		#Move the camera gimbal from side to side, clamp to the limited range.
		var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
		var new_rot_y = cam_gimbal.get_rotation_degrees().y + horizontal_rotation
		cam_gimbal.set_rotation_degrees(Vector3(0, new_rot_y, 0))
		#Move the camera itself up and down, clamp again
		#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
		var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
		var new_rot_x = camera.get_rotation_degrees().x + vertical_rotation
		camera.set_rotation_degrees(Vector3(new_rot_x, -180, 0))
		
		#Emit update signal to turret. First, assemble the camera's quaternion,
		# relative to the tank base. Slightly messy since it has two rotating parts.
		var cam_quat = Quat(camera.get_transform().basis)
		var gimbal_quat = Quat(cam_gimbal.get_transform().basis)
		emit_signal("camera_position_updated", cam_quat, gimbal_quat)
		
		