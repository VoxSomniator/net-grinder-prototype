extends Container

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	UserConfig.connect("config_saved", self, "_on_UserConfig_config_saved")
	$Label.add_color_override("font_color", UserConfig.hud_primary_color)
	$Top.default_color = UserConfig.hud_primary_color
	$Bottom.default_color = UserConfig.hud_primary_color
	$Speed.default_color = UserConfig.hud_primary_color
	$Speed/Line2D.default_color = UserConfig.hud_primary_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	$Label.text = str(VehicleState.ground_speed * 3.6).pad_decimals(1) + " kph"
	$Speed.set_point_position(1, Vector2(0, (VehicleState.ground_speed / VehicleState.max_forward_speed) * -120))
	$Speed/Line2D.position.y = VehicleState.throttle_setting / VehicleState.max_forward_speed * -120

func _on_UserConfig_config_saved():
	$Label.add_color_override("font_color", UserConfig.hud_primary_color)
	$Top.default_color = UserConfig.hud_primary_color
	$Bottom.default_color = UserConfig.hud_primary_color
	$Speed.default_color = UserConfig.hud_primary_color
	$Speed/Line2D.default_color = UserConfig.hud_primary_color