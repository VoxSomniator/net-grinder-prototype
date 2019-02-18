extends VBoxContainer

var weapons_loaded : bool = false

var arm_weapons_added : bool = false

var torso_weapons_added : int = 0

var weapon_panel_scene : PackedScene = preload("res://scenes/testing/test-mech/hud/WeaponPanel.tscn")

var arm_weapon_icon_scene : PackedScene = preload("res://scenes/testing/test-mech/hud/icons/ArmWeaponIcon.tscn")
var torso_weapon_icon_scene : PackedScene = preload("res://scenes/testing/test-mech/hud/icons/TorsoWeaponIcon.tscn")

func _ready():
	VehicleState.connect("weapons_loaded", self, "_on_VehicleState_weapons_loaded")

func _process(delta):
	if weapons_loaded == true && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("ui_down"):
			if VehicleState.selected_weapon < VehicleState.weapons.size() - 1:
				VehicleState.selected_weapon += 1
			else:
				VehicleState.selected_weapon = 0
			VehicleState.emit_signal("weapon_selected", VehicleState.selected_weapon)

		if Input.is_action_just_pressed("ui_up"):
			if VehicleState.selected_weapon > 0:
				VehicleState.selected_weapon -= 1
			else:
				VehicleState.selected_weapon = VehicleState.weapons.size() -1
			VehicleState.emit_signal("weapon_selected", VehicleState.selected_weapon)

		if Input.is_action_just_pressed("ui_right"):
			if VehicleState.selected_weapon_group < VehicleState.weapon_groups.size() - 1:
				VehicleState.selected_weapon_group += 1
			else:
				VehicleState.selected_weapon_group = 0
			VehicleState.emit_signal("weapon_group_selected", VehicleState.selected_weapon_group)

		if Input.is_action_just_pressed("ui_left"):
			if VehicleState.selected_weapon_group > 0:
				VehicleState.selected_weapon_group -= 1
			else:
				VehicleState.selected_weapon_group = VehicleState.weapon_groups.size() -1
			VehicleState.emit_signal("weapon_group_selected", VehicleState.selected_weapon_group)

		if Input.is_action_just_pressed("assign_weapon_grouping"):
			if not VehicleState.weapon_groups[VehicleState.selected_weapon_group].has(VehicleState.weapons[VehicleState.selected_weapon]):
				VehicleState.weapon_groups[VehicleState.selected_weapon_group].append(VehicleState.weapons[VehicleState.selected_weapon])
			elif VehicleState.weapon_groups[VehicleState.selected_weapon_group].has(VehicleState.weapons[VehicleState.selected_weapon]):
				VehicleState.weapon_groups[VehicleState.selected_weapon_group].erase(VehicleState.weapons[VehicleState.selected_weapon])
			VehicleState.emit_signal("weapon_group_assigned", VehicleState.selected_weapon_group)


func _on_VehicleState_weapons_loaded():
	for w in VehicleState.arm_weapons:
		var weapon_panel = weapon_panel_scene.instance()
		add_child(weapon_panel)
		weapon_panel.weapon = w
		weapon_panel.emit_signal("weapon_loaded")
		if get_child_count() == 1:
			var arm_icon = arm_weapon_icon_scene.instance()
			weapon_panel.icon_pos.add_child(arm_icon)
	if get_child_count() == VehicleState.arm_weapons.size():
		arm_weapons_added = true

	if arm_weapons_added == true:
		for w in VehicleState.torso_weapons:
			var weapon_panel = weapon_panel_scene.instance()
			add_child(weapon_panel)
			weapon_panel.weapon = w
			weapon_panel.emit_signal("weapon_loaded")
			if torso_weapons_added == 0:
				var torso_icon = torso_weapon_icon_scene.instance()
				weapon_panel.icon_pos.add_child(torso_icon)

	if get_child_count() == VehicleState.weapons.size():
		weapons_loaded = true