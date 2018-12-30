extends Spatial

onready var pulse_cannon = preload("res://scenes/weapons/PulseCannon.tscn")
onready var missile_launcher = preload("res://scenes/weapons/HeavyArmLauncher.tscn")

onready var weapons = [pulse_cannon, missile_launcher]
onready var weapon_names = ["Pulse Cannon", "Missile Launcher"]

var weapon_group_1 = []

func _ready():
	for w in weapon_names:
		$CanvasLayer/WeaponList.add_item(w)
		$CanvasLayer/ItemList.add_item(w)
	var starting_weapon = weapons[$CanvasLayer/WeaponList.selected].instance()
	$Mount.add_child(starting_weapon)
	weapon_group_1.append($Mount.get_child(0))

func _process(delta):
	$CanvasLayer/WeaponGroups.text = "Weapon Group 1: " + str(weapon_group_1)
	for m in $Mount.get_children():
#        weapon_group_1.append(m)
		if m == null:
			weapon_group_1.erase(m)

func _on_WeaponList_item_selected(ID):
	var weapon_instance = weapons[ID].instance()
	for m in $Mount.get_children():
		weapon_group_1.append(m)
		if m == null:
			weapon_group_1.erase(m)
#        weapon_group_1.remove(0)
#        var removed_weapon = weapon_group_1.find($Mount.get_child(0))
#        weapon_group_1.remove(removed_weapon)
#        m.queue_free()
	$Mount.add_child(weapon_instance)
#    weapon_group_1.clear()
#    weapon_group_1.append($Mount.get_child(0))
