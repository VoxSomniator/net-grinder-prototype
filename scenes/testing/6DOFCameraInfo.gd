extends Label

onready var camera = get_node("../../../Test6DOFJoint/Top")

func _ready():
	pass

func _process(delta):
	text = "X rotation: " + str(camera.rotation_degrees.x) + "\n" \
	+ "Y rotation: " + str(camera.rotation_degrees.y) + "\n" \
	+ "Z rotation: " + str(camera.rotation_degrees.z)
