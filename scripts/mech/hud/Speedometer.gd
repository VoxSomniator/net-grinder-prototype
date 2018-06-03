extends Container

var speed_kph_float
var speed_kph

var throttle
var throttle_percentage
var throttle_reverse_percentage
var max_throttle
var max_throttle_reverse
var throttle_setting
var throttle_setting_percentage
var throttle_reverse_setting_percentage

var user_config

func _ready():
	user_config = get_node("/root/UserConfig")

func _process(delta):
	throttle_percentage = int(throttle / max_throttle * 100)
	throttle_reverse_percentage = int(throttle / max_throttle_reverse * 100) * -1
	throttle_setting_percentage = int(throttle_setting / max_throttle * 100)
	throttle_reverse_setting_percentage  = int(throttle_setting / max_throttle_reverse * 100) * -1
	speed_kph = int(speed_kph_float)
	if speed_kph == 0:
		$Setting/Current/Label.text = str(speed_kph) + " kph"
	else:
		$Setting/Current/Label.text = str(speed_kph_float).pad_decimals(1) + " kph"
	$Setting/Current/Label.modulate = user_config.hud_primary_color
	$Setting.modulate = user_config.hud_primary_color
	$BorderTop.modulate = user_config.hud_primary_color
	$Markers.modulate = user_config.hud_primary_color
	
	set_pointers_position(delta)

func set_pointers_position(delta):
	if throttle_setting == 0:
		$Setting/Setting.position.y = 0
	
	if throttle_setting_percentage > 0:
		$Setting/Setting.position.y = throttle_setting_percentage * -1.2
	elif throttle_reverse_setting_percentage < 0:
		$Setting/Setting.position.y = throttle_reverse_setting_percentage * -0.6
	
	if throttle_percentage == 0:
		$Setting/Current.position.y = 0
	elif throttle_percentage > 0:
		$Setting/Current.position.y = throttle_percentage * -1.2
	elif throttle_reverse_percentage < 0:
		$Setting/Current.position.y = throttle_reverse_percentage * -0.6
	
	$Setting/CurrentBar.set_point_position(1, Vector2(0, $Setting/Current.position.y))
	

func _on_HUDMech_speed_kph_float_updated(new_speed_kph_float):
	speed_kph_float = new_speed_kph_float

func _on_HUDMech_throttle_updated(new_throttle, new_max_throttle, new_max_throttle_reverse, new_throttle_setting):
	throttle = new_throttle
	max_throttle = new_max_throttle
	max_throttle_reverse = new_max_throttle_reverse
	throttle_setting = new_throttle_setting
