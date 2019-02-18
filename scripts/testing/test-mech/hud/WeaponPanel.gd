extends Panel

signal weapon_loaded()

onready var name_label : Node = get_node("Elements/Name")

onready var ammo_label : Node = get_node("Elements/Ammo")

onready var group_labels : Array = [
get_node("Elements/Group1"),
get_node("Elements/Group2"),
get_node("Elements/Group3"),
get_node("Elements/Group4"),
get_node("Elements/Group5"),
get_node("Elements/Group6")
]

onready var icon_pos : Node = get_node("Elements/MountIcon/Position2D")

onready var weapon_selection_outline : Node = get_node("WeaponSelection")

onready var group_1_selection_outline : Node = get_node("GroupSelection/Group1/Selected")
onready var group_2_selection_outline : Node = get_node("GroupSelection/Group2/Selected")
onready var group_3_selection_outline : Node = get_node("GroupSelection/Group3/Selected")
onready var group_4_selection_outline : Node = get_node("GroupSelection/Group4/Selected")
onready var group_5_selection_outline : Node = get_node("GroupSelection/Group5/Selected")
onready var group_6_selection_outline : Node = get_node("GroupSelection/Group6/Selected")

onready var group_selection_outlines : Array = [
group_1_selection_outline,
group_2_selection_outline,
group_3_selection_outline,
group_4_selection_outline,
group_5_selection_outline,
group_6_selection_outline
]

onready var weapon : Object

func _ready():
	connect("weapon_loaded", self, "_on_weapon_loaded")
	VehicleState.connect("weapon_selected", self, "_on_VehicleState_weapon_selected")
	VehicleState.connect("weapon_group_selected", self, "_on_VehicleState_weapon_group_selected")
	VehicleState.connect("weapon_group_assigned", self, "_on_VehicleState_weapon_group_assigned")
	UserConfig.connect("config_saved", self, "_on_UserConfig_config_saved")
	$Elements/Cooldown/Background.default_color = UserConfig.hud_tertiary_color
	$Elements/Cooldown/CooldownBar.default_color = UserConfig.hud_primary_color

func _process(delta):
	if weapon.uses_ammo == true:
		ammo_label.text = str(VehicleState.ammo[weapon.ammo_type])

	if weapon.current_state == "firing":
		$Elements/Cooldown/CooldownBar.set_point_position(1, Vector2(0, 0))
	elif weapon.current_state == "cooldown":
		if weapon.show_cooldown == true:
			$Elements/Cooldown/CooldownBar.set_point_position(1, Vector2((weapon.cooldown_timer / weapon.cooldown) * 50, 0))
#		elif weapon.show_cooldown == false:
#			$Elements/Cooldown/CooldownBar.set_point_position(1, Vector2(0, 0))

func _on_weapon_loaded():
	weapon.connect("weapon_ready", self, "_on_weapon_ready")
	name_label.text = weapon.weapon_name
	if weapon.uses_ammo == false:
		ammo_label.text = "--"
	elif weapon.uses_ammo == true:
		ammo_label.text = str(weapon.ammo_type)
		$Elements/Range.text = str(weapon.optimal_range) + "m"

	if VehicleState.selected_weapon == VehicleState.weapons.find(weapon):
		weapon_selection_outline.show()

	for g in group_selection_outlines:
		if VehicleState.selected_weapon_group == group_selection_outlines.find(g):
			g.show()

	for g in group_labels:
		if not VehicleState.weapon_groups[group_labels.find(g)].has(weapon):
			g.modulate = Color(1.0, 1.0, 1.0, 0.2)

func _on_VehicleState_weapon_selected(index):
	if index == VehicleState.weapons.find(weapon):
		weapon_selection_outline.show()
	else:
		weapon_selection_outline.hide()

func _on_VehicleState_weapon_group_selected(index):
	for g in group_selection_outlines:
		if index == group_selection_outlines.find(g):
			g.show()
		else:
			g.hide()

func _on_VehicleState_weapon_group_assigned(weapon_group):
	if not VehicleState.weapon_groups[weapon_group].has(weapon):
		group_labels[weapon_group].modulate = Color(1.0, 1.0, 1.0, 0.2)
	elif VehicleState.weapon_groups[weapon_group].has(weapon):
		group_labels[weapon_group].modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_weapon_ready():
	$Elements/Cooldown/CooldownBar.set_point_position(1, Vector2(50, 0))

func _on_UserConfig_config_saved():
	$Elements/Cooldown/Background.default_color = UserConfig.hud_tertiary_color
	$Elements/Cooldown/CooldownBar.default_color = UserConfig.hud_primary_color