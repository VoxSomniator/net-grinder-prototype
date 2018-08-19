extends Node

var heat
var heat_capacity = 1000
var heat_dissipation_rate = 0.5

func _ready():
	heat = 0

func _physics_process(delta):
	process_heat(delta)

func process_heat(delta):
	if heat > 0:
		heat -= heat_dissipation_rate
	elif heat < 0:
		heat = 0