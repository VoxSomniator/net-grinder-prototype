extends Node2D

var navpoints_loaded : bool = false

# Target
onready var target_bracket_top_left : Node = get_node("Target/TargetBracketTopLeft")
onready var target_bracket_bottom_right : Node = get_node("Target/TargetBracketBottomRight")
onready var target_bracket_top_right : Node = get_node("Target/TargetBracketTopRight")
onready var target_bracket_bottom_left : Node = get_node("Target/TargetBracketBottomLeft")

func _ready():
	MapState.connect("navpoints_loaded", self, "_on_MapState_navpoints_loaded")
	VehicleState.connect("navpoint_reached", self, "_on_VehicleState_navpoint_reached")

func _process(delta):
	# Waypoint
	if navpoints_loaded == true:
		for n in MapState.nav_points:
			var waypoint = get_node("NavPoints/" + str(n.get_name()))
			if waypoint.get_name() == VehicleState.active_navpoint.get_name():
				var nav_dist : float = n.global_transform.origin.distance_to(VehicleState.body.global_transform.origin)
				if not VehicleState.camera.is_position_behind(n.global_transform.origin):
					waypoint.position = VehicleState.camera.unproject_position(n.global_transform.origin)

				if nav_dist >= 1000:
					waypoint.get_child(0).text = n.navpoint_name + "\n" \
					+ str(nav_dist / 1000).pad_decimals(1) + "km"
				else:
					waypoint.get_child(0).text = n.navpoint_name + "\n" \
					+ str(int(n.global_transform.origin.distance_to(VehicleState.body.global_transform.origin))) + "m"

	# Target
	if VehicleState.current_target != null:
		if not $Target.visible:
			$Target.show()

		if not VehicleState.target_bounds_unprojected.empty():
			# Initialize the points so the bounds can't be made of something not in the array. Initializing them with a Vector2(0, 0) might be incorrect
			var p1 : Vector2 = VehicleState.target_bounds_unprojected[0]
			var p2 : Vector2 = p1

			for i in VehicleState.target_bounds_unprojected:
				p1.x = min(p1.x, i.x)
				p1.y = min(p1.y, i.y)
				p2.x = max(p2.x, i.x)
				p2.y = max(p2.y, i.y)

			# Position the target brackets by these bounds
			if not VehicleState.camera.is_position_behind(VehicleState.current_target.global_transform.origin):
				target_bracket_top_left.position = p1
				target_bracket_bottom_right.position = p2
				target_bracket_top_right.position = Vector2(p2.x, p1.y)
				target_bracket_bottom_left.position = Vector2(p1.x, p2.y)

	elif VehicleState.current_target == null:
		if $Target.visible:
			$Target.hide()

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
