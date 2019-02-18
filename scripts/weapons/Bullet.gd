extends Spatial

const SPEED : int = 700

const KILL_TIMER : int = 2

var timer : float = 0

var hit : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area.connect("body_entered", self, "collided")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var forward_dir = -global_transform.basis.z.normalized()
	global_translate(forward_dir * SPEED * delta)
	timer += delta

	if timer >= KILL_TIMER:
		queue_free()

func collided(body):
	hit = true
	queue_free()