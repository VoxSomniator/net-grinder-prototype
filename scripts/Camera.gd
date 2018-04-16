extends Camera

signal heading_updated(heading)

var heading

func _ready():
	pass

func _process(delta):
	heading = self.rotation_degrees.y
	print(String(heading))
	emit_signal("heading_updated", heading)