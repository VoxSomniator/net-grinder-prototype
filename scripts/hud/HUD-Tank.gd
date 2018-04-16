extends Control

signal heading_updated(heading)

func _ready():
	pass

func _on_Camera_heading_updated(heading):
	print("heading signal debug: HUD-Tank.gd")
	emit_signal("heading_updated", heading)