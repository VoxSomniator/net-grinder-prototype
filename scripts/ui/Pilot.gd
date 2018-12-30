extends ScrollContainer

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	$Control/PilotNameField.add_color_override("font_color", $Control/PilotNameColor.color)
