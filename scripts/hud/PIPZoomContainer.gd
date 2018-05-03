extends Container

var pipcam
var pipzoomviewport

func _ready():
	pipzoomviewport = $ViewportContainer
#	pipzoomviewport.add_child(pipcam)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_HUDTank_pipcam_relayed(received_pipcam):
	pipcam = received_pipcam
