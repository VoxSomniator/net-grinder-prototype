extends Container

var heading
var heading_int
var body_heading
var body_heading_int
var heading_difference
var heading_difference_int
var compass_track
var heading_label
var heading_label_x
var body_heading_label

var dist_left
var dist_right

func _ready():
	compass_track = $CompassTrack
	heading_label = $HeadingLabel
	body_heading_label = $BodyHeadingLabel

func _process(delta):
	compass_track.rect_position.x = (heading * 4) - 2
	
	heading_int = int(heading) * -1 + 360
	if heading_int == 360:
		heading_int = 0
	
	heading_label.text = str(heading_int)
	heading_label_x = heading_label.rect_position.x
	
	body_heading_int = int(body_heading) * -1 + 180
	if body_heading_int < 0:
		body_heading_int += 360
#	if body_heading_int == 360:
#		body_heading_int = 0
	
#	heading_difference = (heading_int - body_heading_int)# * -4
##	if heading_difference < -180:
##		if body_heading_int < 180:
##			heading_difference += 180
			
	if (heading > body_heading):
		dist_left = heading - body_heading
		dist_right  = body_heading + 360 - heading
	else:
		dist_left = heading + 360 - body_heading
		dist_right  = body_heading - heading
	if (dist_left < dist_right):
		heading_difference = dist_left * -1
	else:
		heading_difference = dist_right
	
	heading_difference_int = int(heading_difference)
#	if heading_difference_int < 0:
#		heading_difference_int = (heading_difference_int + 180) * -1
#	if heading_difference_int > 0:
#		heading_difference_int -= 180
	
	body_heading_label.text = str(heading_difference_int)
#	body_heading_label.rect_position.x = (heading_difference_int * 4) + heading_label_x

func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)
	
#	VisualServer.canvas_item_add_clip_ignore(get_canvas_item(), true)

func _on_HUDTank_heading_updated(received_heading):
	heading = received_heading

func _on_HUDTank_body_heading_updated(received_body_heading):
	body_heading = received_body_heading
