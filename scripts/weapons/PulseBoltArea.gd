extends "BaseAreaProjectile.gd"

#const EXPLOSION_WAIT_TIME = 1.5
var explosion_wait_timer = 0

func _init():
	SPEED = 500

func _ready():
	$Area.connect("body_entered", self, "collided")
#	print("connecting")

func _process(delta):
	if hit_something == true:
		$Particles.emitting = true
		$BoltOuter.visible = false
		$BoltCore.visible = false
		explosion_wait_timer += delta
		if explosion_wait_timer > $Particles.lifetime:
			queue_free()


#func collided(body):
#	print("collided")
#	hit_something = true
#	queue_free()