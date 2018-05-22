extends Camera

signal aimpoint_unprojected_updated(aimpoint_unprojected)

var aimpoint
var aimpoint_unprojected

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	aimpoint_unprojected = unproject_position(aimpoint)
	emit_signal("aimpoint_unprojected_updated", aimpoint_unprojected)

func _on_Aimpoint_aimpoint_updated(received_aimpoint):
	aimpoint = received_aimpoint
#	print(aimpoint)
