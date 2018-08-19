extends Spatial

const SPEED = 200
const DAMAGE = 5

var hit_something = false

func _ready():
#	$Area.connect("body_entered", self, "collided")
	pass

func _physics_process(delta):
	var forward_dir = -global_transform.basis.z.normalized()
	global_translate(forward_dir * SPEED * delta)

func collided(body):
#	print("Collided")
	hit_something = true
#	queue_free()