extends Spatial

export var navpoint_name = "Nav Alpha"

export var nav_marker = preload("res://scenes/testing/test-mech/hud/markers/MarkerNav.tscn")

#export(NodePath) var next_navpoint

export var hide_on_reached = true

export var switch_on_reached = true

# Called when the node enters the scene tree for the first time.
func _ready():
#	pass
#	MapState.nav_points.append(self)
	$Area.connect("body_entered", self, "collided")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func collided(body):
	if body.has_method("navpoint_reached"):
		var next_navpoint_index = MapState.nav_points.find(VehicleState.active_navpoint) + 1
		if switch_on_reached == true && next_navpoint_index <= MapState.nav_points.size() - 1:
				VehicleState.active_navpoint = MapState.nav_points[MapState.nav_points.find(VehicleState.active_navpoint) + 1]
		VehicleState.emit_signal("navpoint_reached", self, hide_on_reached, switch_on_reached)