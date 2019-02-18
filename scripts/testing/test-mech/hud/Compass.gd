extends Container

var navpoints_loaded : bool = false

func _ready():
	UserConfig.connect("config_saved", self, "_on_UserConfig_config_saved")
	$Track/Track.modulate = UserConfig.hud_primary_color
	$Pointer.modulate = UserConfig.hud_primary_color
	MapState.connect("navpoints_loaded", self, "_on_MapState_navpoints_loaded")
	MapState.connect("entities_updated", self, "_on_MapState_entities_updated")
	VehicleState.connect("navpoint_reached", self, "_on_VehicleState_navpoint_reached")

func _process(delta):
	$Track/Track.position.x = VehicleState.torso_heading * -3
	$Pointer/Heading.text = str(int(VehicleState.torso_heading))

	if navpoints_loaded == true:
		for n in MapState.nav_points:
			var point = get_node("Track/Markers/" + str(n.get_name()))
			if VehicleState.active_navpoint != null && point.get_name() == VehicleState.active_navpoint.get_name():
				point.position.x = rad2deg(Vector2(VehicleState.body.global_transform.origin.x - n.global_transform.origin.x, VehicleState.body.global_transform.origin.z - n.global_transform.origin.z).angle_to(Vector2(-VehicleState.body.global_transform.basis.z.x, -VehicleState.body.global_transform.basis.z.z))) * -3

	if not MapState.entities.empty() && $Track/Entities.get_child_count() > 0:
		for e in MapState.entities:
			var point = get_node("Track/Entities/" + str(e.get_name()))
			point.position.x = rad2deg(Vector2(VehicleState.body.global_transform.origin.x - e.global_transform.origin.x, VehicleState.body.global_transform.origin.z - e.global_transform.origin.z).angle_to(Vector2(-VehicleState.body.global_transform.basis.z.x, -VehicleState.body.global_transform.basis.z.z))) * -3


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

func _on_MapState_entities_updated(entity):
	var icon_scene = load(entity.icon)
	var entity_icon = icon_scene.instance()
	entity_icon.set_name(entity.get_name())
	$Track/Entities.add_child(entity_icon)

func _on_VehicleState_navpoint_reached(navpoint, hide_on_reached, switch_on_reached):
	if hide_on_reached == true:
		get_node("Track/Markers/" + str(navpoint.get_name())).hide()
	get_node("Track/Markers/" + str(VehicleState.active_navpoint.get_name())).show()

func _on_UserConfig_config_saved():
	$Track/Track.modulate = UserConfig.hud_primary_color
	$Pointer.modulate = UserConfig.hud_primary_color