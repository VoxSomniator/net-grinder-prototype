extends Spatial

const BEAM_DURATION = 1.2
var beam_time = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _physics_process(delta):
	beam_time += delta
	if beam_time >= BEAM_DURATION:
		queue_free()
#    $Outer.SpatialMaterial.emission = Color(0, 1, 1, 0.5)