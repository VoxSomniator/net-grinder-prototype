extends Container

var speed_kph_float
var speed_kph
var vertspeed_float
var vertspeed
var throttle
var throttle_setting
var throttle_percentage
var throttle_setting_percentage

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	speed_kph = int(speed_kph_float)
	vertspeed = int(vertspeed_float)
	throttle_percentage = throttle / 40 * 100
	throttle_setting_percentage = throttle_setting / 40 * 100
	$Inner/Track.rect_position.y = speed_kph_float * 2
	$Inner/Box/Current.text = str(speed_kph) + "kph"
	$VerticalSpeed.text = str(vertspeed) + "m/s"
	$Throttle/Setting/Label.text = str(throttle_setting_percentage)
#	$Throttle/Bar/Current/Label.text = str(throttle)
	$Throttle/Bar.set_point_position(1, Vector2(0, throttle_percentage * -1))
	$Throttle/Setting.position.y = (throttle_setting_percentage * -1) + 100
	$Throttle/Bar/Current.position.y = (throttle_percentage * -1)

func _on_HUDVTOL_speed_kph_float_updated(received_speed_kph_float):
	speed_kph_float = received_speed_kph_float

func _on_HUDVTOL_vertspeed_float_updated(received_vertspeed_float):
	vertspeed_float = received_vertspeed_float


func _on_HUDVTOL_throttle_updated(received_throttle):
	throttle = received_throttle

func _on_HUDVTOL_throttle_setting_updated(received_throttle_setting):
	throttle_setting = received_throttle_setting