extends Container

var body_heading
var body_heading_int

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	body_heading_int = int(body_heading) * -1 + 360
	if body_heading_int == 360:
		body_heading_int = 0
	
	$Inner/Track.rect_position.x = body_heading * 3
	$Pointer/Heading.text = str(body_heading_int)

func _on_HUDVTOL_body_heading_updated(received_body_heading):
	body_heading = received_body_heading
	