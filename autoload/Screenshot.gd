extends Node

var file_prefix = "net grinder prototype"
var file_tag = 0
var output_path = "user://screenshots/"

var _tag = ""
var _index = 0

func _ready():
	if not file_prefix.empty():
		file_prefix += "-"
	set_process_input(true)
	
func _input(event):
	if Input.is_action_just_pressed("screenshot"):
		make_screenshot()

func make_screenshot():
	_check_path(output_path)
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")		
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	_update_tags()
	if _index == 0:
		image.save_png("%s%s%s.png" % [output_path, file_prefix, _tag])
	else:
		image.save_png("%s%s%s_%s.png" % [output_path, file_prefix, _tag, _index])

func _check_path(path):
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)

func _update_tags():
	var time
	if (file_tag == 1): time = str(OS.get_unix_time())
	else:
		time = OS.get_datetime()
		time = "%s%02d%02d-%02d%02d%02d" % [time['year'], time['month'], time['day'], 
											time['hour'], time['minute'], time['second']]
	if (_tag == time): _index += 1
	else:
		_index = 0
	_tag = time	