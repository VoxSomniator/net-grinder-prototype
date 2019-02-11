extends "BaseWeapon.gd"

var laser_beam = preload("res://scenes/testing/laser.tscn")

var burn_time = 1.0
var beam_timer = 0
var beam_spawned = false

func _init():
	cooldown = 3.0

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

		if beam_timer < burn_time:
			$FiringPoint.get_child(0).scale.z = VehicleState.arm_aim_distance * -1
			beam_timer += delta
		elif beam_timer >= burn_time:
			if beam_spawned == true:
				$FiringPoint.get_child(0).queue_free()
				beam_spawned = false
				beam_timer = 0
			current_state = "cooldown"
