extends Control

var user_config
var save_button

func _ready():
	save_button = $SaveButton
	user_config = get_node("/root/UserConfig")
	$ScrollContainer/HUDPanel/HUDPrimaryColor.color = user_config.hud_primary_color
	$ScrollContainer/HUDPanel/HUDSecondaryColor.color = user_config.hud_secondary_color
	$ScrollContainer/HUDPanel/HUDTertiaryColor.color = user_config.hud_tertiary_color

#func _process(delta):
#	$ScrollContainer/BorderTop.set_point_position(1, Vector2($ScrollContainer.rect_size.x, 0))


func _on_SaveButton_pressed():
	user_config.hud_primary_color = $ScrollContainer/HUDPanel/HUDPrimaryColor.color
	user_config.hud_secondary_color = $ScrollContainer/HUDPanel/HUDSecondaryColor.color
	user_config.hud_tertiary_color = $ScrollContainer/HUDPanel/HUDTertiaryColor.color
	
	user_config.write_config()
#	user_config.load_config()
	
	$ScrollContainer/HUDPanel/HUDPrimaryColor.color = user_config.hud_primary_color
	$ScrollContainer/HUDPanel/HUDSecondaryColor.color = user_config.hud_secondary_color
	$ScrollContainer/HUDPanel/HUDTertiaryColor.color = user_config.hud_tertiary_color

func _on_ScrollContainer_resized():
	$ScrollContainer/BorderTop.set_point_position(1, Vector2($ScrollContainer.rect_size.x, 0))
