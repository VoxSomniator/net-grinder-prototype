extends "BaseWeapon.gd"

var bullet_scene = load("res://scenes/weapons/Bullet.tscn")

func _init():
	weapon_name = "Machine gun"
	cooldown = 0.1
	show_cooldown = false
	optimal_range = 300
	uses_ammo = true
	ammo_type = "bullets"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func firing(delta):
	if current_state == "firing" && VehicleState.ammo["bullets"] > 0:
		var bullet = bullet_scene.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(bullet)
		bullet.global_transform = global_transform
		VehicleState.ammo["bullets"] -= 1
		current_state = "cooldown"