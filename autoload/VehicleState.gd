extends Node

signal navpoint_reached(navpoint, hide_on_reached, switch_on_reached)

signal weapons_loaded()
signal weapon_selected(index)
signal weapon_group_selected(index)
signal weapon_group_assigned(weapon_group)

var ground_speed : float = 0

var throttle_setting : float = 0

var max_forward_speed : float = 0

var max_reverse_speed : float = 0

var max_torso_yaw : int = 0
var max_torso_pitch : int = 0

var torso_pitch : float = 0
var torso_yaw : float = 0

var torso_aimpoint_2d : Vector2 = Vector2()
var arm_aimpoint_2d : Vector2 = Vector2()

var arm_aim

var arm_aim_distance : float = 0

var torso_heading : float = 0

var body = NodePath()

var camera = NodePath()

var active_navpoint

# Weapons
onready var weapons : Array = []
onready var arm_weapons : Array = []
onready var torso_weapons : Array = []

# Weapon groups
onready var weapon_group_1 : Array = []
onready var weapon_group_2 : Array = []
onready var weapon_group_3 : Array = []
onready var weapon_group_4 : Array = []
onready var weapon_group_5 : Array = []
onready var weapon_group_6 : Array = []

onready var weapon_groups : Array = [
weapon_group_1,
weapon_group_2,
weapon_group_3,
weapon_group_4,
weapon_group_5,
weapon_group_6
]

var selected_weapon_group : int = 0
var selected_weapon : int = 0

# Ammo
var ammo : Dictionary = {
	"bullets": 0,
}

var beam_weapon_firing : bool = false

var heat : float = 0
var heat_capacity : float = 100
var heat_dissipation : float = 0.05

# Targeting
var current_target : Object
var target_bounds_unprojected : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass