extends Container

var torso_twist
var user_config
var options_menu

func _ready():
	user_config = get_node("/root/UserConfig")
	options_menu = get_node("/root/PauseMenuGlobals")
#	user_config.connect("config_saved", )

#	$TwistLine.default_color = user_config.hud_primary_color
#	$CenterLine.default_color = user_config.hud_primary_color

func _process(delta):
	$TwistLine.set_point_position(1, Vector2(torso_twist, 0))
	$TwistLine.default_color = user_config.hud_primary_color
#	$TwistLine.default_color = user_config.user_config.get_value("hud", "hud_primary_color")
	$CenterLine.default_color = user_config.hud_primary_color

func _on_HUDMech_torso_twist_updated(new_torso_twist):
	torso_twist = new_torso_twist

#func _on_UserConfig_config_saved():
#	$TwistLine.default_color = user_config.hud_primary_color
#	$CenterLine.default_color = user_config.hud_primary_color

#func config_save_button_pressed():
#	$TwistLine.default_color = user_config.hud_primary_color
#	$CenterLine.default_color = user_config.hud_primary_color