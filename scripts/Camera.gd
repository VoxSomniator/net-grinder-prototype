extends Camera

signal heading_updated

var my_heading

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	my_heading = self.rotation_degrees.y
	
	emit_signal("heading_updated", my_heading)