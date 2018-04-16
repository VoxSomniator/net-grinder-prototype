extends Camera

signal heading_updated

var heading

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	heading = self.rotation_degrees.y
	
	emit_signal("heading_updated", heading)