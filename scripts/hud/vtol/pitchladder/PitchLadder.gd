extends Container

var pitch
var roll
var pitch_int
var roll_int

var pitchladder_base
var pitch_base
var pitch_floor

#Pitch lines
var line_0l
var line_0r
var line_pos_0l
var line_pos_0r
var line_neg_0l
var line_neg_0r

var line_5l
var line_5r
var line_pos_5l
var line_pos_5r
var line_neg_5l
var line_neg_5r

var line_10l
var line_10r
var line_pos_10l
var line_pos_10r
var line_neg_10l
var line_neg_10r

var line_15l
var line_15r
var line_pos_15l
var line_pos_15r
var line_neg_15l
var line_neg_15r

var line_20l
var line_20r
var line_pos_20l
var line_pos_20r
var line_neg_20l
var line_neg_20r

var line_minus5l
var line_minus5r
var line_pos_minus5l
var line_pos_minus5r
var line_neg_minus5l
var line_neg_minus5r

var line_minus10l
var line_minus10r
var line_pos_minus10l
var line_pos_minus10r
var line_neg_minus10l
var line_neg_minus10r

var line_minus15l
var line_minus15r
var line_pos_minus15l
var line_pos_minus15r
var line_neg_minus15l
var line_neg_minus15r

var line_minus20l
var line_minus20r
var line_pos_minus20l
var line_pos_minus20r
var line_neg_minus20l
var line_neg_minus20r

#Pitch Labels
var label_0l
var label_0r

var label_5l
var label_5r

var label_10l
var label_10r

var label_15l
var label_15r

var label_20l
var label_20r

var label_minus5l
var label_minus5r

var label_minus10l
var label_minus10r

var label_minus15l
var label_minus15r

var label_minus20l
var label_minus20r

func _ready():
	#Define the lines
	line_0l = $Inner/Ladder/Lines0/LineL
	line_0r = $Inner/Ladder/Lines0/LineL/LineR
	line_pos_0l = $Inner/Ladder/Lines0/LinePosL
	line_pos_0r = $Inner/Ladder/Lines0/LinePosL/LinePosR
	line_neg_0l = $Inner/Ladder/Lines0/LineNegL
	line_neg_0r = $Inner/Ladder/Lines0/LineNegL/LineNegR
	
	line_5l = $Inner/Ladder/Lines5/LineL
	line_5r = $Inner/Ladder/Lines5/LineL/LineR
	line_pos_5l = $Inner/Ladder/Lines5/LinePosL
	line_pos_5r = $Inner/Ladder/Lines5/LinePosL/LinePosR
	line_neg_5l = $Inner/Ladder/Lines5/LineNegL
	line_neg_5r = $Inner/Ladder/Lines5/LineNegL/LineNegR
	
	line_10l = $Inner/Ladder/Lines10/LineL
	line_pos_10l = $Inner/Ladder/Lines10/LinePosL
	line_neg_10l = $Inner/Ladder/Lines10/LineNegL
	
	line_15l = $Inner/Ladder/Lines15/LineL
	line_pos_15l = $Inner/Ladder/Lines15/LinePosL
	line_neg_15l = $Inner/Ladder/Lines15/LineNegL
	
	line_20l = $Inner/Ladder/Lines20/LineL
	line_pos_20l = $Inner/Ladder/Lines20/LinePosL
	line_neg_20l = $Inner/Ladder/Lines20/LineNegL
	
	line_minus5l = $Inner/Ladder/LinesMinus5/LineL
	line_pos_minus5l = $Inner/Ladder/LinesMinus5/LinePosL
	line_neg_minus5l = $Inner/Ladder/LinesMinus5/LineNegL
	
	line_minus10l = $Inner/Ladder/LinesMinus5/LineL
	line_pos_minus10l = $Inner/Ladder/LinesMinus5/LinePosL
	line_neg_minus10l = $Inner/Ladder/LinesMinus5/LineNegL
	
	line_minus15l = $Inner/Ladder/LinesMinus5/LineL
	line_pos_minus15l = $Inner/Ladder/LinesMinus5/LinePosL
	line_neg_minus15l = $Inner/Ladder/LinesMinus5/LineNegL
	
	line_minus20l = $Inner/Ladder/LinesMinus20/LineL
	line_pos_minus20l = $Inner/Ladder/LinesMinus20/LinePosL
	line_neg_minus20l = $Inner/Ladder/LinesMinus20/LineNegL
	
	#Define the labels
	label_0l = $Inner/Ladder/Lines0/Label0L
	label_0r = $Inner/Ladder/Lines0/Label0R
	
	label_5l = $Inner/Ladder/Lines5/Label5L
	label_5r = $Inner/Ladder/Lines5/Label5R
	
	label_10l = $Inner/Ladder/Lines10/Label10L
	label_10r = $Inner/Ladder/Lines10/Label10R
	
	label_15l = $Inner/Ladder/Lines15/Label15L
	label_15r = $Inner/Ladder/Lines15/Label15R
	
	label_20l = $Inner/Ladder/Lines20/Label20L
	label_20r = $Inner/Ladder/Lines20/Label20R
	
	label_minus5l = $Inner/Ladder/LinesMinus5/LabelMinus5L
	label_minus5r = $Inner/Ladder/LinesMinus5/LabelMinus5R
	
	label_minus10l = $Inner/Ladder/LinesMinus10/LabelMinus10L
	label_minus10r = $Inner/Ladder/LinesMinus10/LabelMinus10R
	
	label_minus15l = $Inner/Ladder/LinesMinus15/LabelMinus15L
	label_minus15r = $Inner/Ladder/LinesMinus15/LabelMinus15R
	
	label_minus20l = $Inner/Ladder/LinesMinus20/LabelMinus20L
	label_minus20r = $Inner/Ladder/LinesMinus20/LabelMinus20R

func _process(delta):
	pitchladder_base = fmod((pitch * 20), 400)
	pitch_base = fmod(pitch, 20)
	pitch_floor = pitch - pitch_base
	pitch_int = int(pitch)
	roll_int = int(roll)
	
	$Inner/Ladder.rect_position.y = pitchladder_base
	$Inner.rect_rotation = roll
	
	#Label text
#	label_0l.text = str(pitch_floor)
#	label_0r.text = str(pitch_floor)
	
	label_5l.text = str(pitch_floor + 5)
	label_5r.text = str(pitch_floor + 5)
	
	label_10l.text = str(pitch_floor + 10)
	label_10r.text = str(pitch_floor + 10)
	
	label_15l.text = str(pitch_floor + 15)
	label_15r.text = str(pitch_floor + 15)
	
	label_20l.text = str(pitch_floor + 20)
	label_20r.text = str(pitch_floor + 20)
	
	label_minus5l.text = str(pitch_floor - 5)
	label_minus5r.text = str(pitch_floor - 5)
	
	label_minus10l.text = str(pitch_floor - 10)
	label_minus10r.text = str(pitch_floor - 10)
	
	label_minus15l.text = str(pitch_floor - 15)
	label_minus15r.text = str(pitch_floor - 15)
	
	label_minus20l.text = str(pitch_floor - 20)
	label_minus20r.text = str(pitch_floor - 20)
	
	if pitch_floor == 0:
		label_0l.text = ""
		label_0r.text = ""
	else:
		label_0l.text = str(pitch_floor)
		label_0r.text = str(pitch_floor)
	
	#Line forms, pitch within 20 and -20
	if pitch_floor == 0:
		line_0l.visible = true
		line_0r.visible = true
		line_pos_0l.visible = false
		line_pos_0r.visible = false
		line_neg_0l.visible = false
		line_neg_0r.visible = false
		
		line_5l.visible = false
		line_5r.visible = false
		line_pos_5l.visible = true
		line_pos_5r.visible = true
		line_neg_5l.visible = false
		line_neg_5r.visible = false
		
#		line_10l.visible = false
#		line_10r.visible = false
#		line_pos_10l.visible = true
#		line_pos_10r.visible = true
#		line_neg_10l.visible = false
#		line_neg_10r.visible = false
#
#		line_15l.visible = false
#		line_15r.visible = false
#		line_pos_15l.visible = true
#		line_pos_15r.visible = true
#		line_neg_15l.visible = false
#		line_neg_15r.visible = false
	
	#Line forms, pitch 20 or higher
	elif pitch_floor > 0:
		line_0l.visible = false
		line_0r.visible = false
		line_pos_0l.visible = true
		line_pos_0r.visible = true
		line_neg_0l.visible = false
		line_neg_0r.visible = false
		
	#Line forms, pitch -20 or lower
	elif pitch_floor < 0:
		line_0l.visible = false
		line_0r.visible = false
		line_pos_0l.visible = false
		line_pos_0r.visible = false
		line_neg_0l.visible = true
		line_neg_0r.visible = true

func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)

func _on_HUDVTOL_pitch_updated(received_pitch):
	pitch = received_pitch

func _on_HUDVTOL_roll_updated(received_roll):
	roll = received_roll
