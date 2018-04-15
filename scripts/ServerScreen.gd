extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



func _on_JoinButton_pressed():
	get_parent().on_join_game($Container/PanelContainer/HBoxContainer/JoinSegment/VBoxContainer/LineEdit.text)

func _on_HostButton_pressed():
	get_parent().on_host_game()
