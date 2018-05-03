extends Container

var turret_aimpoint_unprojected
var reticle
var reticle_range_label
var aimpoint_range
var aimpoint_range_int

func _ready():
	reticle = $Reticle
	reticle_range_label = $ReticleRange

func _process(delta):
	rect_position = turret_aimpoint_unprojected
	rect_position.x -= 60
	rect_position.y -= 60
	
	aimpoint_range_int = int(aimpoint_range)
	
	reticle_range_label.text = str(aimpoint_range_int) + "m"

func _on_HUDTank_turret_aimpoint_unprojected_updated(received_turret_aimpoint_unprojected):
	turret_aimpoint_unprojected = received_turret_aimpoint_unprojected

func _on_HUDTank_aimpoint_range_updated(received_aimpoint_range):
	aimpoint_range = received_aimpoint_range