extends RayCast

signal aimpoint_updated(aimpoint)
signal aimpoint_range_updated(aimpoint_range)

var aimpoint
var turret_transform
var endpoint
var aimpoint_range

func _ready():
	endpoint = $Endpoint

func _physics_process(delta):
	aimpoint = $Endpoint.global_transform.origin
	aimpoint_range = get_collision_point().distance_to(global_transform.origin)
	force_raycast_update()
	emit_signal("aimpoint_updated", aimpoint)
	emit_signal("aimpoint_range_updated", aimpoint_range)