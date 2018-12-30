extends Label

onready var trackball_camera = get_node("../TrackballCamera")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	text = "X rotation: " + str(trackball_camera.rotation_degrees.x) + "\n" \
	+ "Y rotation: " + str(trackball_camera.rotation_degrees.y) + "\n" \
	+ "Z rotation: " + str(trackball_camera.rotation_degrees.z)

