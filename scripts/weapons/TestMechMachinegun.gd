extends "BaseWeapon.gd"

var bullet_scene = preload("res://scenes/weapons/Bullet.tscn")

func _init():
	cooldown = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func firing(delta):
	if current_state == "firing":
		var bullet = bullet_scene.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(bullet)
		bullet.global_transform = global_transform
		current_state = "cooldown"