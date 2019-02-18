extends Node

signal navpoints_loaded()
signal navpoint_reached(reached, next)

signal entities_updated(entity)

onready var nav_points : Array = []

var entities : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func next_navpoint(reached, next):
#	emit_signal("navpoint_reached", reached, next)