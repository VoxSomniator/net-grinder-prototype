extends Node

signal config_saved

var create_config_file
var user_config
var err

var hud_primary_color
var hud_secondary_color
var hud_tertiary_color

func _ready():
#	print("ready")
	check_config()
	assign_config_variables()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func check_config():
	#Check if user config file exists, create an empty one if it is not found
	create_config_file = File.new()
	if not create_config_file.file_exists("user://user.ini"):
		create_config_file.open("user://user.ini", create_config_file.WRITE)
		create_config_file.close()
		print("user.ini not found, creating it.")
		
	user_config = ConfigFile.new()
	err = user_config.load("user://user.ini")
	if not err == OK:
		print("failed to load user.ini")
	if err == OK: # if not, something went wrong with the file loading
		#Write in any missing settings with default values
		
		#Default HUD colors
		if not user_config.has_section_key("hud", "primary_color"):
			user_config.set_value("hud", "primary_color", Color(0, 1, 1, 1))
		if not user_config.has_section_key("hud", "secondary_color"):
			user_config.set_value("hud", "secondary_color", Color(1, 1, 0.25, 1))
		if not user_config.has_section_key("hud", "tertiary_color"):
			user_config.set_value("hud", "tertiary_color", Color(1, 0, 0.25, 1))
		
		# Save the changes by overwriting the previous file
		user_config.save("user://user.ini")

func assign_config_variables():
	#HUD
	hud_primary_color = user_config.get_value("hud", "primary_color")
	hud_secondary_color = user_config.get_value("hud", "secondary_color")
	hud_tertiary_color = user_config.get_value("hud", "tertiary_color")

func write_config():
#	user_config = ConfigFile.new()
#	err = user_config.load("user://user.ini")
	check_config()
	if err == OK: # if not, something went wrong with the file loading
		# Save the changes by overwriting the previous file
		user_config.set_value("hud", "primary_color", hud_primary_color)
		user_config.save("user://user.ini")
		emit_signal("config_saved")

func load_config():
	err = user_config.load("user://user.ini")