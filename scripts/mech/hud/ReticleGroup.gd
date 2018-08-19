extends Position2D

var aimpoint_unprojected
var aimpoint_range
#var user_config

func _ready():
#	user_config = get_node("/root/UserConfig")
#	position = Vector2(0, 0)
	pass

func _process(delta):
#	position = aimpoint_unprojected
#	print(aimpoint_unprojected)
	$Group/Range.text = aimpoint_range
	$Group/Range.modulate = UserConfig.hud_primary_color
	$Group/Reticle2.modulate = UserConfig.hud_primary_color.lightened(0.75)

func _on_HUDMech_aimpoint_unprojected_updated(new_aimpoint_unprojected):
	aimpoint_unprojected = new_aimpoint_unprojected
	position = aimpoint_unprojected
#	position.x -= 360
#	position.y -= 200

func _on_HUDMech_aimpoint_range_updated(new_aimpoint_range):
	aimpoint_range = new_aimpoint_range

func _draw():
	$Group/Reticle2.draw_circle(Vector2(36, 36), 3, Color(1, 1, 1, 1))
	var center = Vector2(0, 0)
	var center_left = Vector2(-9, 0)
	var center_right = Vector2(9, 0)
	var radius = 45
	var angle_from = 90
	var angle_to = 180
	var color = UserConfig.hud_primary_color
#	draw_circle_arc(center, radius, angle_from, angle_to, color)
#	draw_circle_arc(center_right, radius, 15, 75, color)
#	draw_circle_arc(center_right, radius, 105, 165, color)
	draw_circle_arc(center_right, radius, 45, 135, color)
#	draw_circle_arc(center_left, radius, 195, 255, color)
#	draw_circle_arc(center_left, radius, 285, 345, color)
	draw_circle_arc(center_left, radius, 225, 315, color)
#	draw_circle_arc(center, radius, )


func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points+1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2, true)