extends Control

signal heading_updated(heading)
signal body_heading_updated(body_heading)
signal pitch_updated(pitch)

func _ready():
	pass

func _on_Camera_heading_updated(heading):
	emit_signal("heading_updated", heading)

func _on_Player_body_heading_updated(body_heading):
	emit_signal("body_heading_updated", body_heading)

func _on_Camera_pitch_updated(pitch):
	emit_signal("pitch_updated", pitch)
