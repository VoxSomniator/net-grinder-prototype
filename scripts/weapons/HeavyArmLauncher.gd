extends "BaseWeapon.gd"

var salvo_size = 15
var missiles_fired = 0

var fire_delay = 0.03
var fire_delay_timer = 0
var weapon_heat = 120

var missile_type = preload("res://scenes/weapons/Missile.tscn")

#var launch_points = []
#var launch_points = [$"launchpoint-1", $"launchpoint-2", $"launchpoint-3", $"launchpoint-4", $"launchpoint-5", \
#$"launchpoint-6", $"launchpoint-7", $"launchpoint-8", $"launchpoint-9", $"launchpoint-10", $"launchpoint-11", \
#$"launchpoint-12", $"launchpoint-13", $"launchpoint-14", $"launchpoint-15"]
#var launch_points = Array()

func _init():
	cooldown = 3.0
#	$LaunchPoints.rotation_degrees.y = 180
#	$"arm-launcher".rotation_degrees.y = 180

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func firing(delta):
	if current_state == "firing":
		if missiles_fired < salvo_size:
			if fire_delay_timer == 0:
				var missile = missile_type.instance()
				var scene_root = get_tree().root.get_children()[0]
				scene_root.add_child(missile)
				missile.global_transform = $LaunchPoints.get_child(randi() % $LaunchPoints.get_child_count()).global_transform
				missiles_fired += 1
				Loadout.heat += (weapon_heat / salvo_size)
				fire_delay_timer += delta
			elif fire_delay_timer > 0:
				if fire_delay_timer < fire_delay:
					fire_delay_timer += delta
				elif fire_delay_timer >= fire_delay:
					fire_delay_timer = 0
		elif missiles_fired >= salvo_size:
			current_state = "cooldown"
			missiles_fired = 0

#func firing(delta):
#	if current_state == "firing":
#		if missiles_fired < salvo_size:
#			var missile = missile_preload.instance()
#			var scene_root = get_tree().root.get_children()[0]
#			scene_root.add_child(missile)
#			missile.global_transform = $LaunchPoints.get_child(randi() % $LaunchPoints.get_child_count()).global_transform
#			missiles_fired += 1
#		elif missiles_fired >= salvo_size:
#			current_state = "cooldown"
#			missiles_fired = 0