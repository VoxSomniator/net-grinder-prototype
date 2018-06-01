extends Container

var speed_kph_float
var speed_kph
var user_config

func _ready():
	user_config = get_node("/root/UserConfig")

func _process(delta):
	speed_kph = int(speed_kph_float)
	if speed_kph == 0:
		$Label.text = str(speed_kph) + " kph"
	else:
		$Label.text = str(speed_kph_float).pad_decimals(1) + " kph"
	$Label.modulate = user_config.hud_primary_color

func _on_HUDMech_speed_kph_float_updated(new_speed_kph_float):
	speed_kph_float = new_speed_kph_float