extends Position2D

# Called when the node enters the scene tree for the first time.
func _ready():
	UserConfig.connect("config_saved", self, "_on_UserConfig_config_saved")
	$Line2D.default_color = UserConfig.hud_primary_color
#	$Line2D2.default_color = UserConfig.hud_primary_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	position = VehicleState.arm_aimpoint_2d

func _draw():
	draw_circle(Vector2(0, 0), 2, UserConfig.hud_primary_color)

func _on_UserConfig_config_saved():
	$Line2D.default_color = UserConfig.hud_primary_color
	$Line2D2.default_color = UserConfig.hud_primary_color
	update()
#	draw_circle(Vector2(0, 0), 2, UserConfig.hud_primary_color)