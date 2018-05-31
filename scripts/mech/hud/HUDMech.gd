extends CanvasLayer

signal torso_twist_updated(torso_twist)

signal heading_updated(heading)

signal aimpoint_unprojected_updated(aimpoint_unprojected)
signal aimpoint_range_updated(aimpoint_range)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_PlayerMechHeavy_torso_twist_updated(torso_twist):
	emit_signal("torso_twist_updated", torso_twist)

func _on_Camera_heading_updated(heading):
	emit_signal("heading_updated", heading)

func _on_Camera_aimpoint_unprojected_updated(aimpoint_unprojected):
	emit_signal("aimpoint_unprojected_updated", aimpoint_unprojected)
#	print("jlkdasjfldaskl", aimpoint_unprojected)

func _on_Aimpoint_aimpoint_range_updated(aimpoint_range):
	emit_signal("aimpoint_range_updated", aimpoint_range)