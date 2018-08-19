extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _draw():
	draw_circle(Vector2(36, 36), 3, Color(1, 1, 1, 1))
#	var center = Vector2(36, 36)
#	var center_left = Vector2(18, 36)
#	var center_right = Vector2(54, 36)
#	var radius = 54
#	var angle_from = 90
#	var angle_to = 180
#	var color = Color(1.0, 1.0, 1.0, 1)
##	draw_circle_arc(center, radius, angle_from, angle_to, color)
#	draw_circle_arc(center_right, radius, 15, 75, color)
#	draw_circle_arc(center_right, radius, 105, 165, color)
#	draw_circle_arc(center_left, radius, 195, 255, color)
#	draw_circle_arc(center_left, radius, 285, 345, color)
##	draw_circle_arc(center, radius, )
#
#
#func draw_circle_arc(center, radius, angle_from, angle_to, color):
#	var nb_points = 32
#	var points_arc = PoolVector2Array()
#
#	for i in range(nb_points+1):
#		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
#		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#
#	for index_point in range(nb_points):
#		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2, true)