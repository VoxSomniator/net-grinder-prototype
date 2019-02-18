extends Control

func _ready():
	$Top.default_color = UserConfig.hud_primary_color
	$Bottom.default_color = UserConfig.hud_primary_color

func _process(delta):
	$Heat.set_point_position(1, Vector2(0, (VehicleState.heat / VehicleState.heat_capacity) * -140))
#	$Label.text = str(int((VehicleState.heat / VehicleState.heat_capacity) * 100)) + "%"
	$Label.text = str(int(VehicleState.heat))

	if VehicleState.heat / VehicleState.heat_capacity <= 0.5:
		$Heat.default_color = UserConfig.hud_primary_color
	elif VehicleState.heat / VehicleState.heat_capacity > 0.5:
		$Heat.default_color = UserConfig.hud_secondary_color
	elif VehicleState.heat / VehicleState.heat_capacity >= 0.8:
		$Heat.default_color = UserConfig.hud_primary_color
