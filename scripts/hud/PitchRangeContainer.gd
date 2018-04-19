extends Container
var pitch
var pitch_int
var pitch_line
var pitch_label

func _ready():
	pitch_line = $PitchLine
	pitch_label = $PitchLine/PitchLabel

func _process(delta):
	pitch_int = int(pitch)
	pitch_line.position.y = pitch * -4 + 180
	pitch_label.text = str(pitch_int) + "°"

func _on_HUDTank_pitch_updated(received_pitch):
	pitch = received_pitch
