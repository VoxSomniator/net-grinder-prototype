extends CanvasLayer

var options_menu

func _ready():
	options_menu = $OptionsMenu
	$PausePanel/OptionsButton.connect("pressed", self, "pause_menu_button_pressed", ["options"])
	$PausePanel/QuitButton.connect("pressed", self, "pause_menu_button_pressed", ["quit"])
	var user_config = get_node("/root/UserConfig")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func pause_menu_button_pressed(button_name):
	if button_name == "options":
			options_menu.visible = true
#			start_menu.visible = false
	elif button_name == "quit":
		get_tree().quit()
#	elif button_name == "start":
#		level_select_menu.visible = true
#		start_menu.visible = false
#	elif button_name == "open_godot":
#		OS.shell_open("https://godotengine.org/")

func _on_PausePanel_resized():
	$PausePanel/BorderRight.set_point_position(1, Vector2(0, $PausePanel.rect_size.y))
