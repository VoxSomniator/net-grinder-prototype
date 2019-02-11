extends Control

var user_config
var save_button

var hud_font = load("res://assets/fonts/hud/NotoSansHUD.tres")

onready var font_size_button = get_node("TabContainer/HUD/HUDPanel/FontSize")

onready var font_sizes = [
10,
12,
14,
18,
24,
36
]

func _ready():
	save_button = $CanvasLayer/SaveButton
	user_config = get_node("/root/UserConfig")
	$TabContainer/HUD/HUDPanel/HUDPrimaryColor.color = user_config.hud_primary_color
	$TabContainer/HUD/HUDPanel/HUDSecondaryColor.color = user_config.hud_secondary_color
	$TabContainer/HUD/HUDPanel/HUDTertiaryColor.color = user_config.hud_tertiary_color

	for f in font_sizes:
		font_size_button.add_item(str(f))

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


func _on_FontSize_item_selected(ID):
	print(font_sizes[ID])
	hud_font.size = font_sizes[ID]
