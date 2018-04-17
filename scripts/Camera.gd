extends Camera

signal heading_updated(heading)

var cam_xform
var heading

func _ready():
	pass

func _process(delta):
	cam_xform = self.get_global_transform()
	heading = rad2deg(Vector2(cam_xform.basis.z.x, cam_xform.basis.z.z).angle_to(Vector2(0,1)))
	if heading<0:
		heading+=360 # beautify heading, remove negative angle
	emit_signal("heading_updated", heading)

#Called by the tank when it becomes the player's active view.
func _on_Player_camera_activated():
	make_current()
