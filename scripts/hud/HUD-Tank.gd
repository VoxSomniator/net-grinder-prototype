extends Control

signal heading_updated(heading)
signal body_heading_updated(body_heading)
signal pitch_updated(pitch)
signal turret_aimpoint_unprojected_updated(turret_aimpoint_unprojected)
signal aimpoint_range_updated(aimpoint_range)
signal pipcam_relayed(pipcam)

func _ready():
	pass

func _on_Camera_heading_updated(heading):
	emit_signal("heading_updated", heading)

func _on_Player_body_heading_updated(body_heading):
	emit_signal("body_heading_updated", body_heading)

func _on_Camera_pitch_updated(pitch):
	emit_signal("pitch_updated", pitch)

func _on_Camera_turret_aimpoint_unprojected_updated(turret_aimpoint_unprojected):
	emit_signal("turret_aimpoint_unprojected_updated", turret_aimpoint_unprojected)

func _on_TurretAimPoint_aimpoint_range_updated(aimpoint_range):
	emit_signal("aimpoint_range_updated", aimpoint_range)

func _on_PIPZoomCamera_pipcam_relayed(pipcam):
	emit_signal("pipcam_relayed")