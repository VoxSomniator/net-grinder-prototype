extends Label

func _ready():
	pass

func _draw():
	VisualServer.canvas_item_add_clip_ignore(get_canvas_item(), true)