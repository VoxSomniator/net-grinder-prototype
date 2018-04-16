extends Container

var heading
var heading_int
var compass_track
var heading_label

func _ready():
	compass_track = $CompassTrack
	heading_label = get_node("../HeadingLabel")

func _process(delta):
	compass_track.rect_position.x = heading * 4
	
	heading_int = int(heading) * -1 + 360
	if heading_int == 360:
		heading_int = 0
	
	heading_label.text = str(heading_int)

func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)

func _on_HUDTank_heading_updated(received_heading):
	heading = received_heading