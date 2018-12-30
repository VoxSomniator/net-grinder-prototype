extends Button

var key_binds = {}

var key_list = {
	"e":KEY_E,
	"k":KEY_K,
	"f11":KEY_F11
   }

var test_key_array = ["freelook", InputEventKey, "K", InputEventKey, "J"]

onready var freelook_action_list = InputMap.get_action_list("freelook")
onready var screenshot_action = InputMap.get_action_list("screenshot")
onready var action_list = InputMap.get_actions()

func _ready():
#    var ev = test_key_array[1].new()
#    ev.scancode = OS.find_scancode_from_string(test_key_array[2])
#    InputMap.action_add_event(test_key_array[0], ev)
#    var ev_alt = test_key_array[3].new()
#    ev_alt.scancode = OS.find_scancode_from_string(test_key_array[4])
#    InputMap.action_add_event(test_key_array[0], ev_alt)
#    text = UserConfig.user_config.get_value("controls:mech/misc", "freelook")[2]
#    print(freelook_action_list)
#    print(screenshot_action)
#    print(action_list)
#    print(key_list.keys())
#    print(test_key_array)
#    print(OS.get_scancode_string(key_list.k.scancode))
#    print(InputEventKey.scancode(KEY_K))
	pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

#func _on_Button_focus_entered():
#    clear()

#func _on_Button_text_entered(new_text):
#    release_focus()

#func _input(event):
#    if (event is InputEventKey):
#        print(OS.get_scancode_string(event.scancode))
#        print(event.scancode)

#func keybind():
#		for action in key_binds.keys():
#			for i in range(key_binds[action].size()):
#				var ev = InputEvent()
#				ev.type = key_binds[action][i]["type"]
#				if (ev.type==InputEvent.KEY):
#					ev.scancode = key_binds[action][i]["scancode"]
#				elif (ev.type==InputEvent.MOUSE_BUTTON):
#					ev.button_index = key_binds[action][i]["button_index"]
#				if (!InputMap.action_has_event(action,ev)):
#					InputMap.action_add_event(action,ev)