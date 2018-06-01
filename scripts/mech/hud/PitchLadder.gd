extends Container

var user_config
var pitch
var pitch_max
var pitch_min
var pitch_up_percentage
var pitch_down_percentage

func _ready():
	user_config = get_node("/root/UserConfig")

func _process(delta):
	pitch_up_percentage = (pitch) / pitch_max * 100
	pitch_down_percentage = (pitch) / pitch_min * 100
	if pitch > 0:
		$Position2D/PitchLine.position.y = pitch_down_percentage * -1.8
	elif pitch < 0:
		$Position2D/PitchLine.position.y = pitch_up_percentage * 1.8
	$Position2D/ConnectorLine.set_point_position(1, Vector2(0, $Position2D/PitchLine.position.y))
	$Position2D/PitchLine/Label.text = str(int(pitch) * -1) + "°"
#	$Position2D/PitchLine/Label.text = "up: " + str(int(pitch_up_percentage)) + "°" + "down: " + str(int(pitch_down_percentage)) + " " + str(int(pitch) * -1)
	$Border.modulate = user_config.hud_primary_color
	$Position2D.modulate = user_config.hud_primary_color
	$CenterVertical.modulate = user_config.hud_primary_color

func _on_HUDMech_body_pitch_updated(body_pitch):
	pitch = body_pitch

func _on_HUDMech_max_rotation_ranges(max_yaw, max_pitch_down, max_pitch_up):
	pitch_max = max_pitch_up
	pitch_min = max_pitch_down