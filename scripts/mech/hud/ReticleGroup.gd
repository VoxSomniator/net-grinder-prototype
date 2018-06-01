extends Position2D

var aimpoint_unprojected
var aimpoint_range
var user_config

func _ready():
	user_config = get_node("/root/UserConfig")

func _process(delta):
#	position = aimpoint_unprojected
#	print(aimpoint_unprojected)
	$Group/Range.text = aimpoint_range
	$Group.modulate = user_config.hud_primary_color

func _on_HUDMech_aimpoint_unprojected_updated(new_aimpoint_unprojected):
	aimpoint_unprojected = new_aimpoint_unprojected
	position = aimpoint_unprojected
	position.x -= 360
	position.y -= 200

func _on_HUDMech_aimpoint_range_updated(new_aimpoint_range):
	aimpoint_range = new_aimpoint_range