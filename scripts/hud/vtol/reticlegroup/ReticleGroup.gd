extends Container
var aimpoint_range
var aimpoint_range_int
var aimpoint_unprojected

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	aimpoint_range_int = int(aimpoint_range)
	$Range.text = str(aimpoint_range_int) + "m"
#	$Reticle.rect_position = aimpoint_unprojected
#	$Reticle.rect_position.x -= 144
#	$Reticle.rect_position.y -= 144

func _on_HUDVTOL_aimpoint_range_updated(received_aimpoint_range):
	aimpoint_range = received_aimpoint_range

func _on_HUDVTOL_aimpoint_unprojected_updated(received_aimpoint_unprojected):
	aimpoint_unprojected = received_aimpoint_unprojected
