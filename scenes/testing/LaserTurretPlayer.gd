extends Spatial

const MOUSE_SENSITIVITY = 0.05

signal camera_position_updated(combined_quat)

onready var camera = $CameraRoot/CameraHolder/Camera
onready var camera_holder = $CameraRoot/CameraHolder
onready var camera_root = $CameraRoot

var dist_left
var dist_right

onready var turret_body = $Body
onready var turret_aim = $Body/TurretAim
var turret_aimpoint
onready var turret_aim_endpoint = $Body/TurretAim/Endpoint

onready var laser = preload("res://scenes/testing/laser.tscn")
onready var laser_top = $Body/LaserTop
onready var laser_2 = $Body/LaserTop2
onready var laser_3 = $Body/LaserTop3
onready var laser_array = [laser_top, laser_2, laser_3]

onready var reticle = get_node("../TurretHUD/Reticle")
onready var range_label = get_node("../TurretHUD/Reticle/Range")
var turret_aim_range
var range_length

var combined_quat

var transverse_speed = 0.05

onready var row_selection = get_node("../TurretHUD/ItemList/ColorRect")
onready var column_selection = get_node("../TurretHUD/ItemList/Panel")

onready var weapon_names = get_node("../TurretHUD/Weapons/WeaponNames")

onready var camera_heading_label = get_node("../TurretHUD/CameraHeading")
onready var heading_difference_label = get_node("../TurretHUD/HeadingDifference")

onready var angle_to_test_label = get_node("../TurretHUD/AngleToTest")
onready var wall = get_node("../Environment/Wall")

onready var rotating_target_root = get_node("../Environment/RotatingTarget")
onready var rotating_target = get_node("../Environment/RotatingTarget/Target")

onready var selected_group_label = get_node("../TurretHUD/SelectedGroup")
var weapon_group_1 = []
var weapon_group_2 = []
var weapon_group_3 = []
var weapon_groups = [weapon_group_1, weapon_group_2, weapon_group_3]
var group_index = 0
var selected_laser = 0

onready var map_things = [wall, rotating_target]

# Compass
onready var compass_track = get_node("../TurretHUD/Compass/Track")
onready var marker_generator = get_node("../TurretHUD/Compass/Markers")

var camera_heading

# Radar
onready var radar = get_node("../TurretHUD/Radar")
#onready var radar_viewport = get_node("../TurretHUD/Radar/Viewport")
#onready var radar_camera = get_node("../TurretHUD/Radar/Viewport/RadarCamera")
onready var blip_generator = get_node("../TurretHUD/Radar/Blips")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	connect("camera_position_updated", self, "_physics_process", [combined_quat])
	for l in laser_array:
		var weapon_label = Label.new()
		weapon_label.text = "Laser"
		weapon_names.add_child(weapon_label)

		var weapon_group_section = preload("res://scenes/testing/WeaponGroupSection.tscn")
		var weapon_group_instance = weapon_group_section.instance()
		weapon_group_instance.get_node("WeaponName").text = "Laser"
		get_node("../TurretHUD/WeaponGroups").rect_size.y += 28
		get_node("../TurretHUD/WeaponGroups/VBoxContainer").add_child(weapon_group_instance)
#        get_node("../TurretHUD/WeaponGroups/Selections").position = get_node("../TurretHUD/WeaponGroups/VBoxContainer").get_children()[1].rect_position
		if get_node("../TurretHUD/WeaponGroups/VBoxContainer").get_child_count() == laser_array.size():
#            print(get_node("../TurretHUD/WeaponGroups/VBoxContainer").get_child_count())
			get_node("../TurretHUD/WeaponGroups/Selections").position.x = get_node("../TurretHUD/WeaponGroups/VBoxContainer").get_children()[0].rect_position.x + 22

	for m in map_things:
		var wall_marker = preload("res://scenes/testing/markers/WallMarker.tscn")
		var radar_blip = preload("res://scenes/testing/markers/WallMarker.tscn")
		var wall_marker_instance = wall_marker.instance()
		var radar_blip_instance = radar_blip.instance()
		wall_marker_instance.set_name(m.get_name())
		radar_blip_instance.set_name(m.get_name())
		radar_blip_instance.position = Vector2(m.global_transform.origin.x, m.global_transform.origin.z)
		marker_generator.add_child(wall_marker_instance)
		blip_generator.add_child(radar_blip_instance)
#    radar_viewport.set_use_own_world(true)
#    radar_camera.custom_viewport = radar_viewport

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _physics_process(delta):
	turn_turret(delta)
	process_raycast(delta)
	process_unproject(delta)
	process_weapons(delta)
	process_input(delta)
	process_angles(delta)
	rotate_target(delta)
	process_radar(delta)

func process_radar(delta):
	for m in map_things:
		var radar_blip = get_node("../TurretHUD/Radar/Blips/" + str(m.get_name()))
		var blip_pos = Vector2(m.global_transform.origin.x, m.global_transform.origin.z)
#        var blip_pos = Vector2(500, 500)
		radar_blip.position = blip_pos
		radar_blip.rotation_degrees = get_facing(m)
	radar.rotation_degrees = camera_heading
#    radar_camera.position = Vector2(global_transform.origin.x, global_transform.origin.z)
#    radar_camera.position = Vector2(500, 500)
#    radar_camera.rotation_degrees += 1

func process_angles(delta):
#    var angle_to_wall = get_angle_to(wall)
#    var angle_to_wall = rad2deg(Vector2(camera.global_transform.basis.z.x, camera.global_transform.basis.z.z).angle_to(Vector2(wall.global_transform.origin.x, wall.global_transform.origin.z)))
#    angle_to_test_label.text = str(angle_to_wall)
#    angle_to_test_label.text = str(rad2deg(wall.to_global(translation).angle_to(camera.get_global_transform().basis.z)))
#    angle_to_test_label.text = str(camera.get_transform().basis.x.angle_to(Vector3(1, 1, 1)))
	camera_heading = rad2deg(Vector2(camera.global_transform.basis.z.x, camera.global_transform.basis.z.z).angle_to(Vector2(0,1)))
	if camera_heading < 0:
		camera_heading += 360
	camera_heading_label.text = str(int(camera_heading * -1 + 360))
	heading_difference_label.text = str(process_angle_to(wall))

	compass_track.rect_position.x = camera_heading * 5

	for m in map_things:
		var mobj = get_node("../TurretHUD/Compass/Markers/" + str(m.get_name()))
		var pos = process_angle_to(m)
#        if m.get_name() == map_things[map_things.find(m.get_name())]:
#        if m.get_name() == m_name:
		mobj.position.x = pos * 5

func get_facing(object):
	var facing = rad2deg(Vector2(object.global_transform.basis.z.x, object.global_transform.basis.z.z).angle_to(Vector2(0,1)))
	if facing < 0:
		facing += 360
	return facing

func get_angle_to(target):
	var target_angle = rad2deg(Vector2(camera.global_transform.basis.z.x, camera.global_transform.basis.z.z).angle_to(Vector2(target.global_transform.origin.x, target.global_transform.origin.z)))
	return target_angle

func process_angle_to(target):
	var target_angle = rad2deg(Vector2(camera.global_transform.basis.z.x, camera.global_transform.basis.z.z).angle_to(Vector2(target.global_transform.origin.x, target.global_transform.origin.z)))

	var marker_angle

	if target_angle < 0:
		marker_angle = target_angle + 360
	else:
		marker_angle = target_angle
	return marker_angle

func process_angle_difference(camera_heading, angle):
	if (camera_heading > angle):
		dist_left = camera_heading - angle
		dist_right  = angle + 360 - camera_heading
	else:
		dist_left = camera_heading + 360 - angle
		dist_right  = angle - camera_heading
	if (dist_left < dist_right):
		var angle_difference = dist_left * -1
		return angle_difference
	else:
		var angle_difference = dist_right
		return angle_difference

func process_weapons(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("fire_selected_weapon"):
			for l in weapon_group_1:
				var laser_instance = laser.instance()
				l.add_child(laser_instance)
				laser_instance.scale.z = range_length * -1
#            laser_instance.scale.z = range_length * -1
#        laser_instance.translate(Vector3(0, 0, -1))

		if Input.is_action_just_pressed("fire_weapon_2"):
			for l in weapon_group_2:
				var laser_instance = laser.instance()
				l.add_child(laser_instance)
				laser_instance.scale.z = range_length * -1

		if Input.is_action_just_pressed("fire_weapon_group_3"):
			for l in weapon_group_3:
				var laser_instance = laser.instance()
				l.add_child(laser_instance)
				laser_instance.scale.z = range_length * -1

#        for l in laser_array:
#            for b in l.get_child(1):
#                b.scale.z = range_length * -1

	if Input.is_action_just_pressed("ui_right"):
		if group_index < weapon_groups.size() - 1:
			group_index += 1
		else:
			group_index = 0
	if Input.is_action_just_pressed("ui_left"):
		if group_index > 0:
			group_index -= 1
		else:
			group_index = weapon_groups.size() - 1
	selected_group_label.text = "selected weapon group: " + str(group_index) + "\n" \
	+ "selected laser: " + str(selected_laser) + "\n" \
	+ "weapon group 1: " + str(weapon_group_1) + "\n" \
	+ "weapon group 2: " + str(weapon_group_2) + "\n" \
	+ "weapon group 3: " + str(weapon_group_3)

	if Input.is_action_just_pressed("ui_down"):
		if selected_laser < laser_array.size() - 1:
			selected_laser += 1
		else:
			selected_laser = 0
	if Input.is_action_just_pressed("ui_up"):
		if selected_laser > 0:
			selected_laser -= 1
		else:
			selected_laser = laser_array.size() -1

	if Input.is_action_just_pressed("assign_weapon_grouping"):
		if not weapon_groups[group_index].has(laser_array[selected_laser]):
			weapon_groups[group_index].append(laser_array[selected_laser])
		elif weapon_groups[group_index].has(laser_array[selected_laser]):
			weapon_groups[group_index].erase(laser_array[selected_laser])

#    get_node("../TurretHUD/WeaponGroups/Selections").position = get_node("../TurretHUD/WeaponGroups/VBoxContainer").get_child(0).rect_position

func turn_turret(delta):
	var turret_body_quat = Quat(turret_body.transform.basis).normalized()
	var camera_root_quat = Quat(camera_root.transform.basis)
	var turret_body_transform_rotation = Transform(turret_body_quat.slerp(camera_root_quat, transverse_speed))
	turret_body_transform_rotation.origin = turret_body.transform.origin
	turret_body.transform = turret_body_transform_rotation

func process_raycast(delta):
	if turret_aim.is_colliding():
		turret_aimpoint = turret_aim.get_collision_point()
		turret_aim_range = str(int(turret_aim.get_collision_point().distance_to(to_global(translation)))) + "m"
		range_length = int(turret_aim.get_collision_point().distance_to(to_global(translation)))
	else:
		turret_aimpoint = turret_aim_endpoint.global_transform.origin
		turret_aim_range = "--m"
		range_length = int(1000)
	range_label.text = turret_aim_range
	for l in laser_array:
		l.look_at(turret_aimpoint, Vector3(0, 0, 1))

func process_unproject(delta):
	var aimpoint_unprojected = camera.unproject_position(turret_aimpoint)
	reticle.position = aimpoint_unprojected

func rotate_target(delta):
#    rotating_target_root.rotation_degrees.y += delta
	rotating_target_root.rotate_object_local(Vector3(0, 1, 0), 0.008)

func process_input(delta):
	if Input.is_action_just_pressed("ui_up"):
		row_selection.rect_position.y -= 20
	elif Input.is_action_just_pressed("ui_down"):
		row_selection.rect_position.y += 20
	if Input.is_action_just_pressed("ui_left"):
		column_selection.rect_position.x -= 20
	elif Input.is_action_just_pressed("ui_right"):
		column_selection.rect_position.x += 20

func process_freelook(delta):
	#Freelook quaternions
	var camera_holder_quat = Quat(Vector3(0, 1, 0), camera_holder.rotation.y).normalized()
#    var camera_holder_quat = Quat(camera_holder.transform.basis)
	var camera_quat = Quat(Vector3(1, 0, 0), camera.rotation.x).normalized()
#    var camera_quat = Quat(camera.transform.basis)
	var zero_quat = Quat(Vector3(1, 1, 0), 0).normalized()

	var camera_holder_quat_rotation = Transform(camera_holder_quat.slerp(zero_quat, 0.2))
	var camera_quat_rotation = Transform(camera_quat.slerp(zero_quat, 0.2))

	camera_holder_quat_rotation.origin = camera_holder.transform.origin
	camera_quat_rotation.origin = camera.transform.origin

	#Face forward again when freelook is released
	if not Input.is_action_pressed("freelook"):
		camera_holder.transform = camera_holder_quat_rotation
		camera.transform = camera_quat_rotation
#    #Freelook quaternions
#    var camera_holder_quat = Quat(Vector3(0, 1, 0), camera_holder.rotation.y).normalized()
#    var camera_quat = Quat(Vector3(1, 0, 0), camera.rotation.x).normalized()
#    var zero_quat = Quat(Vector3(1, 1, 0), 0).normalized()
#
#    var camera_holder_quat_rotation = Transform(camera_holder_quat.slerp(zero_quat, 0.2))
#    var camera_quat_rotation = Transform(camera_quat.slerp(zero_quat, 0.2))
#
#    camera_holder_quat_rotation.origin = camera_holder.transform.origin
#    camera_quat_rotation.origin = camera.transform.origin
#
#    #Face forward again when freelook is released
#    if not Input.is_action_pressed("freelook"):
#        camera_holder.transform = camera_holder_quat_rotation
#        camera.transform = camera_quat_rotation
#    var camera_quat = Quat(camera.transform.basis).normalized()
#    var camera_quat_x = Quat(Vector3(1, 0, 0), camera.rotation.x).normalized()
#    var zero_quat = Quat(Vector3(1, 1, 0), 0).normalized()
#
#    var camera_quat_rotation = Transform(camera_quat.slerp(zero_quat, 0.2))
#    camera_quat_rotation.origin = camera.transform.origin
#
#    if not Input.is_action_pressed("freelook"):
#        camera.transform = camera_quat_rotation

func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_pressed("freelook"):
					#Move the camera gimbal from side to side, clamp to the limited range.
	#		camera_holder.rotation_degrees.y = clamp(camera_holder.rotation_degrees.y, -30, 30)
	#		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -10, 20)
			var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
			var new_rot_y_2 = camera_holder.get_rotation_degrees().y + horizontal_rotation
			camera_holder.set_rotation_degrees(Vector3(0, new_rot_y_2, 0))
			#Move the camera itself up and down, clamp again
			#Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
			var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
			var new_rot_x_2 = camera.get_rotation_degrees().x + vertical_rotation
			camera.set_rotation_degrees(Vector3(new_rot_x_2, -180, 0))

			#Emit update signal to turret. First, assemble the camera's quaternion,
			# relative to the tank base. Slightly messy since it has two rotating parts.
#			var cam_quat = Quat(camera.get_transform().basis)
#	#		var cam_quat = Quat(Vector3(1, 0, 0), new_rot_x * -0.01)
#			var gimbal_quat = Quat(camera_holder.get_transform().basis)
#			var combined_quat = Quat(Vector3(0, 1, 0), deg2rad(new_rot_y)) * Quat(Vector3(-1, 0, 0), deg2rad(new_rot_x))
#	#		var combined_quat = Quat(Vector3(0, 0, 1), PI) * gimbal_quat * cam_quat
#			emit_signal("camera_position_updated", cam_quat, gimbal_quat, combined_quat)

#        else:
#            #Move the camera gimbal from side to side, clamp to the limited range.
#    #		camera_holder.rotation_degrees.y = clamp(camera_holder.rotation_degrees.y, -30, 30)
#    #		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -10, 20)
#            var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
#            var new_rot_y = camera_holder.get_rotation_degrees().y + horizontal_rotation
#            camera_holder.set_rotation_degrees(Vector3(0, new_rot_y, 0))
#            #Move the camera itself up and down, clamp again
#            #Some of the lines have 180 added/subtracted because the camera is turned around to face forward, it's weird
#            var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
#            var new_rot_x = camera.get_rotation_degrees().x + vertical_rotation
#            camera.set_rotation_degrees(Vector3(new_rot_x, 0, 0))
#        if Input.is_action_pressed("freelook"):
#            var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
#            var new_rot_y = camera.get_rotation_degrees().y + horizontal_rotation
#            var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY * -1
#            var new_rot_x = camera.get_rotation_degrees().x + vertical_rotation
#            camera.set_rotation_degrees(Vector3(new_rot_x, new_rot_y, 0))
		else:
			var horizontal_rotation = event.relative.x * MOUSE_SENSITIVITY * -1
			var new_rot_y = camera_root.get_rotation_degrees().y + horizontal_rotation
			var vertical_rotation = event.relative.y * MOUSE_SENSITIVITY
			var new_rot_x = camera_root.get_rotation_degrees().x + vertical_rotation
			camera_root.set_rotation_degrees(Vector3(new_rot_x, new_rot_y, 0))

#        combined_quat = Quat(Vector3(0, 1, 0), deg2rad(new_rot_y)) * Quat(Vector3(-1, 0, 0), deg2rad(new_rot_x))
#        emit_signal("camera_position_updated", combined_quat)
#        print(combined_quat)