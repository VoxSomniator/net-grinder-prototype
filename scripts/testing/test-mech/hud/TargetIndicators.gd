extends Node2D

var navpoints_loaded = false

func _ready():
	MapState.connect("navpoints_loaded", self, "_on_MapState_navpoints_loaded")
	VehicleState.connect("navpoint_reached", self, "_on_VehicleState_navpoint_reached")

func _process(delta):
	if navpoints_loaded == true:
		for n in MapState.nav_points:
			var waypoint = get_node("NavPoints/" + str(n.get_name()))
			if waypoint.get_name() == VehicleState.active_navpoint.get_name():
				var nav_dist = n.global_transform.origin.distance_to(VehicleState.body.global_transform.origin)
				if not VehicleState.camera.is_position_behind(n.global_transform.origin):
					waypoint.position = VehicleState.camera.unproject_position(n.global_transform.origin)

				if nav_dist >= 1000:
					waypoint.get_child(0).text = n.navpoint_name + "\n" \
					+ str(nav_dist / 1000).pad_decimals(1) + "km"
				else:
					waypoint.get_child(0).text = n.navpoint_name + "\n" \
					+ str(int(n.global_transform.origin.distance_to(VehicleState.body.global_transform.origin))) + "m"

func _on_MapState_navpoints_loaded():
	for n in MapState.nav_points:
		var waypoint_indicator_preload = preload("res://scenes/testing/test-mech/hud/WaypointHUD.tscn")
		var waypoint_indicator = waypoint_indicator_preload.instance()
		var nav_marker = n.nav_marker.instance()
		waypoint_indicator.set_name(n.get_name())
		waypoint_indicator.get_child(1).add_child(nav_marker)
		$NavPoints.add_child(waypoint_indicator)
#		navpoints_loaded = true

	if $NavPoints.get_child_count() == MapState.nav_points.size():
		navpoints_loaded = true

	if navpoints_loaded == true:
		for w in $NavPoints.get_children():
			w.get_child(0).add_color_override("font_color", UserConfig.hud_primary_color)
			if w.get_name() != VehicleState.active_navpoint.get_name():
				w.hide()

func _on_VehicleState_navpoint_reached(navpoint, hide_on_reached, switch_on_reached):
	if hide_on_reached == true:
		get_node("NavPoints/" + str(navpoint.get_name())).hide()
	get_node("NavPoints/" + str(VehicleState.active_navpoint.get_name())).show()
