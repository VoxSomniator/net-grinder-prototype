extends Container

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	UserConfig.connect("config_saved", self, "_on_UserConfig_config_saved")
	modulate = UserConfig.hud_primary_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$Center/Pitch.position.y = VehicleState.torso_pitch / VehicleState.max_torso_pitch * 180
	$Center/Pitch/Label.text = str(int(VehicleState.torso_pitch) * -1) + "°"
	$Center/PitchRight.position.y = VehicleState.torso_pitch / VehicleState.max_torso_pitch * 180
	$Center/PitchRight/Label.text = str(int(VehicleState.torso_pitch) * -1) + "°"

func _on_UserConfig_config_saved():
	modulate = UserConfig.hud_primary_color