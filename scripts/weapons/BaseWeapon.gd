extends Spatial

var states = ["ready", "firing", "cooldown", "destroyed"]

var current_state = null

var cooldown = 0
var cooldown_timer

func _ready():
	cooldown_timer = 0
	current_state = "ready"

func _physics_process(delta):
	firing(delta)
	cooldown_state(delta)

func fire():
	if current_state == "ready":
#		print("firing")
		current_state = "firing"

func firing(delta):
	if current_state == "firing":
		current_state = "cooldown"

func cooldown_state(delta):
	if current_state == "cooldown":
#		print("cooldown")
		if cooldown_timer < cooldown:
			cooldown_timer += delta
		elif cooldown_timer >= cooldown:
#			print("ready")
			current_state = "ready"
			cooldown_timer = 0

func destroyed():
	current_state = "destroyed"