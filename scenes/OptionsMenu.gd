extends Control

var user_config
var save_button

func _ready():
	save_button = $CanvasLayer/SaveButton
	user_config = get_node("/root/UserConfig")
	$TabContainer/HUD/HUDPanel/HUDPrimaryColor.color = user_config.hud_primary_color
	$TabContainer/HUD/HUDPanel/HUDSecondaryColor.color = user_config.hud_secondary_color
	$TabContainer/HUD/HUDPanel/HUDTertiaryColor.color = user_config.hud_tertiary_color

#func _process(delta):
#	$ScrollContainer/BorderTop.set_point_position(1, Vector2($ScrollContainer.rect_size.x, 0))


func _on_SaveButton_pressed():
	user_config.hud_primary_color = $TabContainer/HUD/HUDPanel/HUDPrimaryColor.color
	user_config.hud_secondary_color = $TabContainer/HUD/HUDPanel/HUDSecondaryColor.color
	user_config.hud_tertiary_color = $TabContainer/HUD/HUDPanel/HUDTertiaryColor.color

	user_config.write_config()
#	user_config.load_config()

	$TabContainer/HUD/HUDPanel/HUDPrimaryColor.color = user_config.hud_primary_color
	$TabContainer/HUD/HUDPanel/HUDSecondaryColor.color = user_config.hud_secondary_color
	$TabContainer/HUD/HUDPanel/HUDTertiaryColor.color = user_config.hud_tertiary_color

func _on_ScrollContainer_resized():
	$TabContainer/HUD/BorderTop.set_point_position(1, Vector2($TabContainer.rect_size.x, 0))
