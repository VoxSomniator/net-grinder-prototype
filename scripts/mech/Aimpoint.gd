extends RayCast

signal aimpoint_updated(aimpoint)
signal aimpoint_range_updated(aimpoint_range)

var aimpoint
var aimpoint_range

func _ready():
	pass

func _process(delta):
	if is_colliding():
		aimpoint = get_collision_point()
		aimpoint_range = str(int(get_collision_point().distance_to(to_global(translation)))) + "m"
#		emit_signal("aimpoint_updated", aimpoint)
#		emit_signal("aimpoint_range_updated", aimpoint_range)
#		print("signal")
	else:
		aimpoint = $Endpoint.global_transform.origin
		aimpoint_range = ""
#		emit_signal("aimpoint_updated", aimpoint)
#		emit_signal("aimpoint_range_updated", aimpoint_range)
#		print("signal")
	emit_signal("aimpoint_updated", aimpoint)
	emit_signal("aimpoint_range_updated", aimpoint_range)
	force_raycast_update()
#	print("sent_signal")
#	print(aimpoint)