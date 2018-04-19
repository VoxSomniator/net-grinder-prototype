extends Container

var turret_aimpoint_unprojected

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	rect_position = turret_aimpoint_unprojected
	rect_position.x -= 40
	rect_position.y -= 40

func _on_HUDTank_turret_aimpoint_unprojected_updated(received_turret_aimpoint_unprojected):
	turret_aimpoint_unprojected = received_turret_aimpoint_unprojected
