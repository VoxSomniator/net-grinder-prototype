extends StaticBody

var icon : String = "res://scenes/testing/test-mech/hud/icons/TargetIcon.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	MapState.entities.append(self)
	MapState.emit_signal("entities_updated", self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
