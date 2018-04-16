extends Container

#var tank_camera
#var tank_cam_heading
#var tank_cam_heading_int

func _ready():
#	tank_camera = get_parent().get_node("Camera")
	pass


#func _process(delta):
##	tank_cam_heading = tank_camera.rotation_degrees.y
##	tank_cam_heading_int = int(tank_cam_heading)
##
##	$CompassTrack.rect_position.x = tank_cam_heading

func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
