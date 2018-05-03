extends Camera

signal pipcam_relayed(pipcam)

var pipcam = self

func _ready():
	pass

func _process(delta):
#	emit_signal("pipcam_relayed", pipcam)
	global_transform = get_parent().get_parent().get_parent().get_parent().global_transform