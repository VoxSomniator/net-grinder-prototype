extends Camera

signal heading_updated(heading)

var cam_xform
var heading

func _ready():
	pass

func _process(delta):
	cam_xform = self.get_global_transform()
	heading = cam_xform.rotation_degrees.y
	print(String(heading))
	emit_signal("heading_updated", heading)