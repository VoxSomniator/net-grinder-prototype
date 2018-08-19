extends Container

var user_config
var heat
var heat_percentage
var heat_capacity
var heat_dissipation_rate

func _ready():
	user_config = get_node("/root/UserConfig")

func _process(delta):
#	heat_percentage = heat_capacity / heat * 100
	heat_percentage = Loadout.heat / Loadout.heat_capacity * 100
	$BorderTop.modulate = UserConfig.hud_primary_color.lightened(0.8)
	$Markers.modulate = user_config.hud_primary_color.lightened(0.8)
	$Percentage.modulate = user_config.hud_primary_color
	$Heat.modulate = user_config.hud_primary_color
	
#	if heat_percentage <= 100:
	$CurrentHeat.set_point_position(1, Vector2(0, heat_percentage * -1.8))
	if $CurrentHeat.get_point_position(1).y < -180:
		$CurrentHeat.set_point_position(1, Vector2(0, -180))
	
	$Percentage.text = str(int(heat_percentage)) + "%"
	$Heat.text = str(int(Loadout.heat) + 273)+ "°k"
	
#	$BorderTop.modulate = user_config.hud_primary_color
	if heat_percentage < 50:
		$CurrentHeat.modulate = user_config.hud_primary_color
	elif heat_percentage > 50:
		if heat_percentage < 75:
			$CurrentHeat.modulate = user_config.hud_secondary_color
		elif heat_percentage > 75:
			$CurrentHeat.modulate = user_config.hud_tertiary_color
#	print(heat_percentage)

func _on_HUDMech_heat_updated(new_heat, new_heat_capacity, new_heat_dissipation_rate):
	heat = new_heat
	heat_capacity = new_heat_capacity
	heat_dissipation_rate = new_heat_dissipation_rate
#	heat_percentage = heat / heat_capacity * 100