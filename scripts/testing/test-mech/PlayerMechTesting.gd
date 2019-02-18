extends Spatial

func _ready():
	MapState.nav_points = [
	$NavPoints/NavPoint,
	$NavPoints/NavPoint2,
	$NavPoints/NavPoint3
	]
	VehicleState.active_navpoint = $NavPoints/NavPoint

	MapState.emit_signal("navpoints_loaded")

	print(MapState.nav_points[MapState.nav_points.find(VehicleState.active_navpoint)])
#	print(MapState.nav_points.find(VehicleState.active_navpoint) + 1)
#	print(MapState.nav_points.size() - 1)
#	print(VehicleState.active_navpoint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
