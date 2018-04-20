extends RayCast

signal aimpoint_updated(turret_aimpoint)
signal aimpoint_range_updated(aimpoint_range)

var turret_aimpoint
var turret_transform
var endpoint
var aimpoint_range

func _ready():
	endpoint = $Endpoint

func _process(delta):
	turret_aimpoint = endpoint.global_transform.origin
	aimpoint_range = get_collision_point().distance_to(global_transform.origin)
	self.transform = turret_transform
	force_raycast_update()
	emit_signal("aimpoint_updated", turret_aimpoint)
	emit_signal("aimpoint_range_updated", aimpoint_range)

func _on_Skeleton_turret_transform_updated(received_turret_transform):
	turret_transform = received_turret_transform
