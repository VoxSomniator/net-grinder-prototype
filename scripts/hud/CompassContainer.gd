extends Container

var heading
var compass_track
var heading_label

func _ready():
	compass_track = $CompassTrack
	heading_label = $HeadingLabel

func _process(delta):
	compass_track.rect_position.x = heading * 2
	heading_label.text = str(heading)

func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)
	VisualServer.canvas_item_add_clip_ignore(heading_label, true)

func _on_HUDTank_heading_updated(received_heading):
	heading = received_heading