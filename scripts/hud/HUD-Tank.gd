extends Control

signal heading_updated(heading)

func _ready():
	pass

func _on_Camera_heading_updated(heading):
	emit_signal("heading_updated", heading)