extends "BaseWeapon.gd"

#var cooldown = 1.0
var weapon_heat = 7

var pulse_bolt = preload("res://scenes/weapons/PulseBoltArea.tscn")

func _init():
	cooldown = 0.25

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _physics_process(delta):
#	firing(delta)
#	cooldown(delta)

func firing(delta):
	if current_state == "firing":
		var bolt = pulse_bolt.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(bolt)
		bolt.global_transform = global_transform
		Loadout.heat += weapon_heat
#		print("fire")
		current_state = "cooldown"