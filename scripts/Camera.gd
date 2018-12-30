extends Camera

signal heading_updated(heading)
signal pitch_updated(pitch)
signal turret_aimpoint_unprojected_updated(turret_aimpoint_unprojected)

var cam_xform
var heading
var pitch
var turret_aimpoint
var turret_aimpoint_unprojected

func _ready():
	pass

func _process(delta):
	cam_xform = self.get_global_transform()

	heading = rad2deg(Vector2(cam_xform.basis.z.x, cam_xform.basis.z.z).angle_to(Vector2(0,1)))
	if heading < 0:
		heading += 360 # beautify heading, remove negative angle

	pitch = self.rotation_degrees.x

	turret_aimpoint_unprojected = unproject_position(turret_aimpoint)

	emit_signal("heading_updated", heading)
	emit_signal("pitch_updated", pitch)
	emit_signal("turret_aimpoint_unprojected_updated", turret_aimpoint_unprojected)

#Called by the tank when it becomes the player's active view.
func _on_Player_camera_activated():
	make_current()

func _on_TurretAimPoint_aimpoint_updated(received_turret_aimpoint):
	turret_aimpoint = received_turret_aimpoint
