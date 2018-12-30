extends ScrollContainer

onready var keybind_prompt = get_node("../../CanvasLayer/KeybindPrompt")

onready var freelook_button = get_node("Categories/Mech/VBoxContainer/SetControlsMovement/BindButtons/ButtonFreelook")
onready var freelook_alt_button = get_node("Categories/Mech/VBoxContainer/SetControlsMovement/BindButtonsAlt/ButtonFreelookAlt")
onready var freelook_binding = UserConfig.user_config.get_value("controls:mech/misc", "freelook")

var key_binds = {
	"mech_freelook" : [freelook_button, freelook_alt_button, freelook_binding, "controls:mech/misc", "freelook", "InputEventType", "InputEvent", "AltInputEventType", "AltInputEvent"]
   }

func _ready():
#    freelook_button.text = freelook_binding[2]
#    assign_bindings_from_config()
	pass
#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

#func _input(event):
#    if keybind_prompt.visible:
#        var ev = InputEvent.new()
#        if ev.type == InputEventKey:
#            pressed_button.
# Connect "on press" signals from each button with a parameter of the keybind dict key

func assign_bindings_from_config():
	for k in key_binds:
		k[0].text = k[2]
#        if not [4] == "null":
#            UserConfig.user_config.set_value([2], [3])

#func assign_alt_bindings():

func _on_ButtonFreelook_pressed():
	var dict_key = key_binds.mech_freelook
