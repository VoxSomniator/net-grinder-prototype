extends Container

var heading
var pointerheading
var user_config

func _ready():
	user_config = get_node("/root/UserConfig")

func _process(delta):
	pointerheading = int(heading) * -1 + 360
	if pointerheading == 360:
		pointerheading = 0

	$Inner/Track.rect_position.x = heading * 3
	$Pointer/Label.text = str(pointerheading)

	$Inner.modulate = user_config.hud_primary_color
	$Pointer.modulate = user_config.hud_primary_color
	$Border.modulate = user_config.hud_primary_color

func _on_HUDMech_heading_updated(new_heading):
	heading = new_heading
