extends "BaseWeapon.gd"

var laser_beam = preload("res://scenes/testing/laser.tscn")

var burn_time = 1.3
var beam_timer = 0
var beam_spawned = false

func _init():
	weapon_name = "Laser"
	cooldown = 3.0
	uses_ammo = false
	optimal_range = 500
	weapon_heat = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func firing(delta):
	if current_state == "firing":
		if beam_spawned == false:
			var beam = laser_beam.instance()
			$FiringPoint.add_child(beam)
			beam_spawned = true
			VehicleState.beam_weapon_firing = true

		if beam_timer < burn_time:
			if VehicleState.arm_aim.is_colliding():
				if $FiringPoint.get_child_count() > 0:
					$FiringPoint.get_child(0).scale.z = VehicleState.arm_aim_distance * -1
			else:
				if $FiringPoint.get_child_count() > 0:
					$FiringPoint.get_child(0).scale.z = -1500
			VehicleState.heat += (weapon_heat / burn_time) * delta
			beam_timer += delta
		elif beam_timer >= burn_time:
			if beam_spawned == true:
				for c in $FiringPoint.get_children():
					c.queue_free()
				beam_spawned = false
				beam_timer = 0
				VehicleState.beam_weapon_firing = false
			current_state = "cooldown"
