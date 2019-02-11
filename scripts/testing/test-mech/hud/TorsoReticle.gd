extends Position2D

onready var lines = [
$OuterBottomLeft,
$OuterBottomRight,
$OuterTopLeft,
$OuterTopRight,
$InnerBottomLeft,
$InnerBottomRight,
$InnerTopLeft,
$InnerTopRight
]

# Called when the node enters the scene tree for the first time.
func _ready():
	UserConfig.connect("config_saved", self, "_on_UserConfig_config_saved")
	for l in lines:
		l.default_color = UserConfig.hud_primary_color
	$Range.add_color_override("font_color", UserConfig.hud_primary_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	position = VehicleState.torso_aimpoint_2d
	if VehicleState.arm_aim.is_colliding():
		$Range.text = str(int(VehicleState.arm_aim_distance)) + "m"
	else:
		$Range.text = "1500+ m"

func _on_UserConfig_config_saved():
	for l in lines:
		l.default_color = UserConfig.hud_primary_color
	$Range.add_color_override("font_color", UserConfig.hud_primary_color)