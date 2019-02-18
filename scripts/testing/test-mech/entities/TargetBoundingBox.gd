extends StaticBody

func _ready():
	pass # Replace with function body.

func _process(delta):
	if VehicleState.current_target == get_parent():
		VehicleState.target_bounds_unprojected = [
		VehicleState.camera.unproject_position($CollisionShape/Position3D.global_transform.origin),
		VehicleState.camera.unproject_position($CollisionShape/Position3D2.global_transform.origin),
		VehicleState.camera.unproject_position($CollisionShape/Position3D3.global_transform.origin),
		VehicleState.camera.unproject_position($CollisionShape/Position3D4.global_transform.origin),
		VehicleState.camera.unproject_position($CollisionShape/Position3D5.global_transform.origin),
		VehicleState.camera.unproject_position($CollisionShape/Position3D6.global_transform.origin),
		VehicleState.camera.unproject_position($CollisionShape/Position3D7.global_transform.origin),
		VehicleState.camera.unproject_position($CollisionShape/Position3D8.global_transform.origin),
		]

func targeted():
	VehicleState.current_target = get_parent()
	print(VehicleState.current_target.get_name())