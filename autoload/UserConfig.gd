extends Node

signal config_saved

var create_config_file
var user_config
var err
var hud_primary_color

func _ready():
	print("ready")
	#Creates an empty config file if one is not found
	create_config_file = File.new()
	if not create_config_file.file_exists("user://user.cfg"):
		create_config_file.open("user://user.cfg", create_config_file.WRITE)
		create_config_file.close()
		print("user.cfg does not exist, creating it.")
	
	user_config = ConfigFile.new()
	err = user_config.load("user://user.cfg")
	if not err == OK:
		print("failed")
	if err == OK: # if not, something went wrong with the file loading
		# Look for the display/width pair, and default to 1024 if missing
#		var screen_width = get_value("display", "width", 1024)
		# Store a variable if and only if it hasn't been defined yet
		print("OK")
		if not user_config.has_section_key("hud", "primary_color"):
			user_config.set_value("hud", "primary_color", Color(0, 1, 1, 1))
		# Save the changes by overwriting the previous file
		user_config.save("user://user.cfg")
		hud_primary_color = user_config.get_value("hud", "primary_color")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func write_config():
#	user_config = ConfigFile.new()
#	err = user_config.load("user://user.cfg")
	if err == OK: # if not, something went wrong with the file loading
		# Look for the display/width pair, and default to 1024 if missing
#		var screen_width = get_value("display", "width", 1024)
		# Store a variable if and only if it hasn't been defined yet
#		if not user_config.has_section_key("hud", "primary_color"):
#			user_config.set_value("hud", "primary_color", Color(0, 1, 1, 1))
		# Save the changes by overwriting the previous file
		user_config.set_value("hud", "primary_color", hud_primary_color)
		user_config.save("user://user.cfg")
		emit_signal("config_saved")

func load_config():
	err = user_config.load("user://user.cfg")