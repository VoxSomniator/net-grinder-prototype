extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	transform = get_node("../MechHeavy/Armature/Skeleton").get_bone_transform(10)
#	print(translation)
#	translation = get_node("../MechHeavy/Armature/Skeleton").get_bone_transform(10)
#	transform = get_node("../MechHeavy/Armature/Skeleton/cockpit").transform
#	translation = get_node("../MechHeavy/Armature/Skeleton/cockpit").translation
#	transform = get_node("../M")