extends Control

var user_config
var save_button

func _ready():
	save_button = $Panel/SaveButton
	user_config = get_node("/root/UserConfig")
	$Panel/HUDPrimaryColor.color = user_config.hud_primary_color

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_SaveButton_pressed():
	user_config.hud_primary_color = $Panel/HUDPrimaryColor.color
	user_config.write_config()
#	user_config.load_config()
	$Panel/HUDPrimaryColor.color = user_config.hud_primary_color