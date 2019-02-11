extends Node

onready var nav_points = []
signal navpoints_loaded()
signal navpoint_reached(reached, next)

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func next_navpoint(reached, next):
	emit_signal("navpoint_reached", reached, next)