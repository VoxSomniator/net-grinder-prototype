extends Camera

signal heading_updated(heading)

var heading

func _ready():
	pass

func _process(delta):
	heading = self.rotation_degrees.y
	print("signal debug: Camera.gd")
	emit_signal("heading_updated", heading)