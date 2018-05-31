extends AnimationTreePlayer

var throttle
var node_list = get_node_list()
var animation_position

func _ready():
	print(node_list)
	active = true
#	active = false

func _process(delta):
#	animation_position = animation_node_get_master_animation("anim 2")
#	print(animation_position)
	if throttle == 0:
		blend2_node_set_amount("run", 0)
		blend2_node_set_amount("walk", 0)
		blend2_node_set_amount("jog", 0)
	if throttle > 0:
		transition_node_set_current("transition", 0)
		blend2_node_set_amount("run", 1)
		blend2_node_set_amount("walk", 1)
		blend2_node_set_amount("jog", 1)
#	if throttle > 25:
#		if transition_node_get_current("transition") != 1:
#			transition_node_set_current("transition", 1)
#			blend2_node_set_amount("walk", 1)
#			blend2_node_set_amount("jog", 1)
#			blend2_node_set_amount("run", 1)
#	if throttle > 50:
#		if transition_node_get_current("transition") != 2:
#			transition_node_set_current("transition", 2)
#			blend2_node_set_amount("walk", 1)
#			blend2_node_set_amount("jog", 1)
#			blend2_node_set_amount("run", 1)

func _on_PlayerMechHeavy_throttle_updated(new_throttle):
	throttle = new_throttle