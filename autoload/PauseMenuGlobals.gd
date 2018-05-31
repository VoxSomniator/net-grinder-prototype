extends Node

var canvas_layer = null

const PAUSE_MENU_SCENE = preload("res://scenes/PauseMenu.tscn")
var pause_menu = null

func _ready():
#	canvas_layer =
	pass 

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if pause_menu == null:
			pause_menu = PAUSE_MENU_SCENE.instance()
#			print("instanced")
			
#			popup.get_node("Button_quit").connect("pressed", self, "popup_quit")
#			popup.connect("popup_hide", self, "popup_closed")
#			popup.get_node("Button_resume").connect("pressed", self, "popup_closed")
#			canvas_layer.add_child(pause_menu)
			add_child(pause_menu)
#			popup.popup_centered()
#			if Input.is_action_just_pressed("ui_cancel"):
#				if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
#					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#				else:
#					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#			get_tree().paused = true
		else:
			pause_menu_closed()

func pause_menu_closed():
#	get_tree().paused = false
	if pause_menu != null:
		pause_menu.queue_free()
		pause_menu = null
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)