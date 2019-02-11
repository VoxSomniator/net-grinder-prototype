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
	$Center/Twist.position.x = VehicleState.torso_yaw / VehicleState.max_torso_yaw * -137
	if VehicleState.torso_yaw < 0:
		$Center/Twist/Label.text = str(int(VehicleState.torso_yaw * -1))
	else:
		$Center/Twist/Label.text = str(int(VehicleState.torso_yaw))
	$Center/Connector.set_point_position(1, Vector2($Center/Twist.position.x, 0))

func _on_UserConfig_config_saved():
	modulate = UserConfig.hud_primary_color