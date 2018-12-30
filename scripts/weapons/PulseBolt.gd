extends "BaseRigidProjectile.gd"

var heat = 20

func _init():
	SPEED = 500
#	connect("body_entered", self, "collided")

func _ready():
	connect("body_entered", self, "collided")

#func _physics_process(delta):
#	var forward_dir = -global_transform.basis.z.normalized()
#	global_translate(forward_dir * 500 * delta)

#func _integrate_forces(state):
#	set_linear_velocity(Vector3(0, 0, 15))

#func collided(body):
#	hit_something = true
#	print("collided")
#	queue_free()