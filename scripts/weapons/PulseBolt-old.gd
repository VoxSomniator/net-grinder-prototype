extends KinematicBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print("fire")

func _physics_process(delta):
#	global_translate(Vector3(0, 0, 1))
#	move_and_collide(Vector3(0, 0, 1))
	translation.z -= get_parent().translation.z + 1
#	move_and_slide()