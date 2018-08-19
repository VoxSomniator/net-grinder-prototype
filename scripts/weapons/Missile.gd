extends "BaseAreaProjectile.gd"

#const SPEED = 500
var explosion_wait_timer = 0

func _init():
	SPEED = 400

func _ready():
	$Area.connect("body_entered", self, "collided")

func _process(delta):
	if hit_something == true:
		$Explosion.emitting = true
		$missile.visible = false
		explosion_wait_timer += delta
		if explosion_wait_timer > $Explosion.lifetime:
			queue_free()