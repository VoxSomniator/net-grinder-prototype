extends RayCast

signal aimpoint_updated(turret_aimpoint)

var turret_aimpoint
var turret_transform
var endpoint
var endpoint_position

func _ready():
	endpoint = $EndPoint

func _process(delta):
	turret_aimpoint = endpoint.global_transform.origin
	self.transform = turret_transform
	force_raycast_update()
	emit_signal("aimpoint_updated", turret_aimpoint)

func _on_Skeleton_turret_transform_updated(received_turret_transform):
	turret_transform = received_turret_transform
