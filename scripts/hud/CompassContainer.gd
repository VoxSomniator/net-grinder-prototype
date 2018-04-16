extends Container

var heading

func _ready():
	pass

func _process(delta):
	$CompassTrack.rect_position.x = heading

func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)

func _on_HUDTank_heading_updated(received_heading):
	heading = received_heading