extends Container

var altitude
var elevation

var temp_altitude
var temp_altitude_upper_50
var temp_altitude_upper_100
var temp_altitude_upper_150
var temp_altitude_upper_200
var temp_altitude_upper_250
var temp_altitude_upper_300
var temp_altitude_upper_350
var temp_altitude_lower_50
var temp_altitude_lower_100
var temp_altitude_lower_150
var temp_altitude_lower_200
var temp_altitude_lower_250
var temp_altitude_lower_300
var temp_altitude_lower_350

var temp_elevation
var temp_elevation_upper_50
var temp_elevation_upper_100
var temp_elevation_upper_150
var temp_elevation_upper_200
var temp_elevation_upper_250
var temp_elevation_upper_300
var temp_elevation_upper_350
var temp_elevation_lower_50
var temp_elevation_lower_100
var temp_elevation_lower_150
var temp_elevation_lower_200
var temp_elevation_lower_250
var temp_elevation_lower_300
var temp_elevation_lower_350

var altimeter_altitude
var altimeter_elevation
var altimeter_elevation_2

var altitude_int
var elevation_int

var label_0
var label_50
var label_100
var label_150
var label_200
var label_250
var label_300
var label_350
var label_400
var label_minus50
var label_minus100
var label_minus150
var label_minus200
var label_minus250
var label_minus300
var label_minus350
var label_minus400

func _ready():
	label_0 = $Inner/Track/Line0/Label0
	label_50 = $Inner/Track/LinePlus50/LabelPlus50
	label_100 = $Inner/Track/LinePlus100/LabelPlus100
	label_150 = $Inner/Track/LinePlus150/LabelPlus150
	label_200 = $Inner/Track/LinePlus200/LabelPlus200
	label_250 = $Inner/Track/LinePlus250/LabelPlus250
	label_300 = $Inner/Track/LinePlus300/LabelPlus300
	label_350 = $Inner/Track/LinePlus350/LabelPlus350
	label_400 =  $Inner/Track/LinePlus400/LabelPlus400
	label_minus50 = $Inner/Track/LineMinus50/LabelMinus50
	label_minus100 = $Inner/Track/LineMinus100/LabelMinus100
	label_minus150 = $Inner/Track/LineMinus150/LabelMinus150
	label_minus200 = $Inner/Track/LineMinus200/LabelMinus200
	label_minus250 = $Inner/Track/LineMinus250/LabelMinus250
	label_minus300 = $Inner/Track/LineMinus300/LabelMinus300
	label_minus350 = $Inner/Track/LineMinus350/LabelMinus350
	label_minus400 = $Inner/Track/LineMinus400/LabelMinus400

func _process(delta):
	altitude_int = int(altitude)
	elevation_int = int(elevation)
	
	#Temporary altitude. Godot returns an error if modulo is used on floating point numbers, so have to use floor instead
#	temp_altitude = altitude - altitude % 250
#	temp_altitude = altitude - altitude * floor(altitude / 250)
	temp_altitude = fmod(altitude - altitude, 250)
	
	temp_altitude_upper_50 = temp_altitude + 50
	temp_altitude_upper_100 = temp_altitude + 100
	temp_altitude_upper_150 = temp_altitude + 150
	temp_altitude_upper_200 = temp_altitude + 200
	temp_altitude_upper_250 = temp_altitude + 250
	temp_altitude_upper_300 = temp_altitude + 300
	temp_altitude_upper_350 = temp_altitude + 350
	
	temp_altitude_lower_50 = temp_altitude - 50
	temp_altitude_lower_100 = temp_altitude - 100
	temp_altitude_lower_150 = temp_altitude - 150
	temp_altitude_lower_200 = temp_altitude - 200
	temp_altitude_lower_250 = temp_altitude - 250
	temp_altitude_lower_300 = temp_altitude - 300
	temp_altitude_lower_350 = temp_altitude - 350
	
	#Temporary elevation
#	temp_elevation = elevation - elevation % 250
	temp_elevation = fmod(elevation, 250)
	
	temp_elevation_upper_50 = temp_elevation + 50
	temp_elevation_upper_100 = temp_elevation + 100
	temp_elevation_upper_150 = temp_elevation + 150
	temp_elevation_upper_200 = temp_elevation + 200
	temp_elevation_upper_250 = temp_elevation + 250
	temp_elevation_upper_300 = temp_elevation + 300
	temp_elevation_upper_350 = temp_elevation + 350
	
	temp_elevation_lower_50 = temp_elevation - 50
	temp_elevation_lower_100 = temp_elevation - 100
	temp_elevation_lower_150 = temp_elevation - 150
	temp_elevation_lower_200 = temp_elevation - 200
	temp_elevation_lower_250 = temp_elevation - 250
	temp_elevation_lower_300 = temp_elevation - 300
	temp_elevation_lower_350 = temp_elevation - 350
	
	#altimeter temp position values
	altimeter_altitude = altitude - temp_altitude
	altimeter_elevation = elevation - temp_elevation
	altimeter_elevation_2 = temp_elevation - elevation
	
	
	
	$Inner/Track.rect_position.y = temp_elevation
	$Inner/Box/Current.text = str(elevation_int) + "m"
	$Altitude.text = "[" + str(altitude_int) + "m]"
	
	label_0.text = str(altimeter_elevation)
	label_50.text = str(altimeter_elevation + 50)
	label_100.text = str(altimeter_elevation + 100)
	label_150.text = str(altimeter_elevation + 150)
	label_200.text = str(altimeter_elevation + 200)
	label_250.text = str(altimeter_elevation + 250)
	label_300.text = str(altimeter_elevation + 300)
	label_350.text = str(altimeter_elevation + 350)
	label_400.text = str(altimeter_elevation + 400)
	label_minus50.text = str(altimeter_elevation - 50)
	label_minus100.text = str(altimeter_elevation - 100)
	label_minus150.text = str(altimeter_elevation - 150)
	label_minus200.text = str(altimeter_elevation - 200)
	label_minus250.text = str(altimeter_elevation - 250)
	label_minus300.text = str(altimeter_elevation - 300)
	label_minus350.text = str(altimeter_elevation - 350)
	label_minus400.text = str(altimeter_elevation - 400)
	
	if elevation < 200:
		$Inner/GroundIndicator.rect_position.y = elevation
	
	if elevation < 150:
		$Inner/Track/LineMinus50.visible = false
		$Inner/Track/LineMinus100.visible = false
		$Inner/Track/LineMinus150.visible = false
		$Inner/Track/LineMinus200.visible = false
		$Inner/Track/LineMinus250.visible = false
		$Inner/Track/LineMinus300.visible = false
		$Inner/Track/LineMinus350.visible = false
		$Inner/Track/LineMinus400.visible = false
	else:
		$Inner/Track/LineMinus50.visible = true
		$Inner/Track/LineMinus100.visible = true
		$Inner/Track/LineMinus150.visible = true
		$Inner/Track/LineMinus200.visible = true
		$Inner/Track/LineMinus250.visible = true
		$Inner/Track/LineMinus300.visible = true
		$Inner/Track/LineMinus350.visible = true
		$Inner/Track/LineMinus400.visible = true

#func _draw():
#	VisualServer.canvas_item_set_clip($Inner, true)

func _on_HUDVTOL_altitude_updated(received_altitude):
	altitude = received_altitude

func _on_HUDVTOL_elevation_updated(received_elevation):
	elevation = received_elevation