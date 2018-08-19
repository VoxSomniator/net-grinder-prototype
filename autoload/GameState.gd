extends Node

var game_state

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	set_mouse_mode(delta)

func set_mouse_mode(delta):
	if PauseMenuGlobals.pause_menu != null:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif PauseMenuGlobals.pause_menu == null:
		if game_state == 1 && Console.isConsoleShown == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Console.isConsoleShown:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	elif Console.isConsoleShown == false:
#		if game_state == 1:
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)