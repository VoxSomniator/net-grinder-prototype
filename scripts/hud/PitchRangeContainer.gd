extends Container
var pitch
var pitch_line

func _ready():
	pitch_line = $PitchLine

func _process(delta):
	pitch_line.position.y = pitch * -4 + 180

func _on_HUDTank_pitch_updated(received_pitch):
	pitch = received_pitch
