extends Control

var navpoints_loaded = false

func _ready():
	MapState.connect("navpoints_loaded", self, "_on_MapState_navpoints_loaded")
	VehicleState.connect("navpoint_reached", self, "_on_VehicleState_navpoint_reached")
	$Viewport/Player/ViewCenter.default_color = UserConfig.hud_primary_color
	$Viewport/Player/ViewCenter/Polygon2D.color = UserConfig.hud_primary_color
	$Viewport/Player/ViewconeL/Line2D.default_color = UserConfig.hud_primary_color
	$Viewport/Player/ViewconeR/Line2D.default_color = UserConfig.hud_primary_color
	$Radius.add_color_override("font_color", UserConfig.hud_primary_color)

func _process(delta):
	if navpoints_loaded == true:
		for n in MapState.nav_points:
			var blip = get_node("Viewport/Blips/" + str(n.get_name()))
			if blip.get_name() == VehicleState.active_navpoint.get_name():
				var pos_x = n.global_transform.origin.x - VehicleState.body.global_transform.origin.x
				var pos_y = n.global_transform.origin.z - VehicleState.body.global_transform.origin.z
				blip.position = Vector2(pos_x * -0.125, pos_y * -0.125)

	$Viewport/Blips.rotation_degrees = VehicleState.torso_heading * -1
	$Viewport/Player/LegsFacing.rotation_degrees = VehicleState.body.rotation_degrees.y

	$TextureRect.texture = $Viewport.get_texture()

func _on_MapState_navpoints_loaded():
	for n in MapState.nav_points:
		var nav_marker = n.nav_marker.instance()
		nav_marker.set_name(n.get_name())
		nav_marker.set_scale(Vector2(0.5, 0.5))
		$Viewport/Blips.add_child(nav_marker)
#		navpoints_loaded = true

	if $Viewport/Blips.get_child_count() == MapState.nav_points.size():
		navpoints_loaded = true

	if navpoints_loaded == true:
		for b in $Viewport/Blips.get_children():
			if b.get_name() != VehicleState.active_navpoint.get_name():
				b.hide()

func _on_VehicleState_navpoint_reached(navpoint, hide_on_reached, switch_on_reached):
	if hide_on_reached == true:
		get_node("Viewport/Blips/" + str(navpoint.get_name())).hide()
	get_node("Viewport/Blips/" + str(VehicleState.active_navpoint.get_name())).show()

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 1)

func _draw():
	var center = Vector2(125, 125)
	var radius = 125
	var angle_from = 0
	var angle_to = 360
	var color = UserConfig.hud_primary_color
	draw_circle_arc(center, radius, angle_from, angle_to, color)
