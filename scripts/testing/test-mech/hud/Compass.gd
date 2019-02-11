extends Container

var navpoints_loaded = false

#onready var nav_points = MapState.nav_points
var nav_marker = preload("res://scenes/testing/test-mech/hud/markers/MarkerNav.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	UserConfig.connect("config_saved", self, "_on_UserConfig_config_saved")
	$Track/Track.modulate = UserConfig.hud_primary_color
	$Pointer.modulate = UserConfig.hud_primary_color
	MapState.connect("navpoints_loaded", self, "_on_MapState_navpoints_loaded")
	VehicleState.connect("navpoint_reached", self, "_on_VehicleState_navpoint_reached")

#	print(nav_points)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$Track/Track.position.x = VehicleState.torso_heading * -3
	$Pointer/Heading.text = str(int(VehicleState.torso_heading))

	if navpoints_loaded == true:
		for n in MapState.nav_points:
			var point = get_node("Track/Markers/" + str(n.get_name()))
			if VehicleState.active_navpoint != null && point.get_name() == VehicleState.active_navpoint.get_name():
				point.position.x = rad2deg(Vector2(VehicleState.body.global_transform.origin.x - n.global_transform.origin.x, VehicleState.body.global_transform.origin.z - n.global_transform.origin.z).angle_to(Vector2(-VehicleState.body.global_transform.basis.z.x, -VehicleState.body.global_transform.basis.z.z))) * -3

#		point.position.x = rad2deg(Vector2(VehicleState.body.global_transform.basis.z.x, VehicleState.body.global_transform.basis.z.z).angle_to(Vector2(n.global_transform.origin.x, n.global_transform.origin.z))) * 3
#
#		point.position.x = rad2deg(Vector2(VehicleState.body.global_transform.basis.z.x, VehicleState.body.global_transform.basis.z.z).angle_to(Vector2(VehicleState.body.global_transform.origin.x - n.global_transform.origin.x, VehicleState.body.global_transform.origin.z - n.global_transform.origin.z))) * 3
#		point.position.x = rad2deg(Vector2(VehicleState.body.global_transform.origin.x - n.global_transform.origin.x, VehicleState.body.global_transform.origin.z - n.global_transform.origin.z).angle_to(Vector2(VehicleState.body.global_transform.basis.z.x, VehicleState.body.global_transform.basis.z.z))) * -3

#		var dir = (n.global_transform.origin - VehicleState.body.global_transform.origin).inverse()
#		var dir = Vector2(n.global_transform.origin.x, n.global_transform.origin.z) - Vector2(VehicleState.body.global_transform.basis.z.x, VehicleState.body.global_transform.basis.z.z)
#		var angle = rad2deg(atan2(-dir.x, dir.y))
#		point.position.x = angle * 3

#		point.position.x = rad2deg(n.global_transform.origin.angle_to(VehicleState.body.global_transform.basis.z)) * 3

#		point.position.x = rad2deg(Vector2(n.global_transform.origin.x, n.global_transform.origin.z).angle_to(Vector2(VehicleState.body.global_transform.origin.x - n.global_transform.origin.x, VehicleState.body.global_transform.origin.z - n.global_transform.origin.z))) * 3

#		point.position.x = rad2deg(Vector2(n.global_transform.origin.x, n.global_transform.origin.z).angle_to(Vector2(VehicleState.body.global_transform.origin.x, VehicleState.body.global_transform.origin.z))) * 3

#		point.position.x = rad2deg(Vector2(n.global_transform.origin.x, n.global_transform.origin.z).angle_to(Vector2(VehicleState.body.global_transform.basis.z.x, VehicleState.body.global_transform.basis.z.z))) * 3
#		point.position.x = rad2deg(Vector2(VehicleState.body.global_transform.basis.z.x, VehicleState.body.global_transform.basis.z.z).angle_to(Vector2(n.global_transform.origin.x - VehicleState.body.global_transform.basis.z.x, n.global_transform.origin.z - VehicleState.body.global_transform.basis.z.z))) * 3
#		point.position.x = rad2deg(Vector2(-VehicleState.body.translation.x, -VehicleState.body.translation.z).angle_to(Vector2(n.translation.x - VehicleState.body.translation.x, n.translation.z - VehicleState.body.translation.z))) * 3
#		point.position.x = rad2deg(Vector2(to_global(VehicleState.body.translation.x)), VehicleState.body.translation.z).angle_to(Vector2(n.translation.x, n.translation.z)) * 3
#		point.position.x = rad2deg(Vector2(0, 0).angle_to(Vector2))
#		point.position.x = process_angle_to(n)
#		point.position.x = rad2deg(VehicleState.body.global_transform.basis.z.angle_to(n.global_transform.origin)) * 3
#		point.position.x = rad2deg(VehicleState.body.global_transform.origin.angle_to(n.global_transform.origin))

#func process_angle_to(target):
#	var target_angle = rad2deg(VehicleState.body_pos.angle_to(Vector2(target.global_transform.x, target.global_transform.z)))
#	print(VehicleState.body_pos)
#	return target_angle * 3

func _on_MapState_navpoints_loaded():
		for n in MapState.nav_points:
	#		var g = preload(n.nav_marker)
			var m = n.nav_marker.instance()
			m.set_name(n.get_name())
			$Track/Markers.add_child(m)
	#		print(m)
		if $Track/Markers.get_child_count() == MapState.nav_points.size():
			navpoints_loaded = true

		if navpoints_loaded == true:
			print($Track/Markers.get_children())
			for m in $Track/Markers.get_children():
				if m.name != VehicleState.active_navpoint.get_name():
					m.hide()

func _on_VehicleState_navpoint_reached(navpoint, hide_on_reached, switch_on_reached):
	if hide_on_reached == true:
		get_node("Track/Markers/" + str(navpoint.get_name())).hide()
	get_node("Track/Markers/" + str(VehicleState.active_navpoint.get_name())).show()

func _on_UserConfig_config_saved():
	$Track/Track.modulate = UserConfig.hud_primary_color
	$Pointer.modulate = UserConfig.hud_primary_color