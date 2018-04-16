extends Container

var heading
var compass_track

func _ready():
	compass_track = $CompassTrack

func _process(delta):
	compass_track.rect_position.x = heading * 4

func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)

func _on_HUDTank_heading_updated(received_heading):
	heading = received_heading