extends RigidBody

var timer
var lifespan = 5

func _ready():
	timer = Timer.new()
	timer.wait_time = lifespan
	timer.connect("timeout",self,"_timeout")
	add_child(timer)
	timer.start()

func _timeout():
	get_parent().remove_child(self)