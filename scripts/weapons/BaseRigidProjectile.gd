extends RigidBody

const SPEED = 200
const DAMAGE = 5

var hit_something = false

func _ready():
	connect("body_entered", self, "collided")

func _physics_process(delta):
	var forward_dir = -global_transform.basis.z.normalized()
	global_translate(forward_dir * SPEED * delta)

func collided(body):
	hit_something = true
	print("collided")
	queue_free()