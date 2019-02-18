extends Spatial

signal weapon_ready

var weapon_name : String

var states : Array = ["ready", "firing", "cooldown", "destroyed"]

var current_state : String

var cooldown : float = 0
var cooldown_timer : float = 0

var show_cooldown : bool = true

var optimal_range : int = 500

var uses_ammo : bool

var ammo_type : String

var weapon_heat : float

func _ready():
	current_state = "ready"

func _physics_process(delta):
	firing(delta)
	cooldown_state(delta)

func fire():
	if current_state == "ready":
		current_state = "firing"

func firing(delta):
	if current_state == "firing":
		current_state = "cooldown"

func cooldown_state(delta):
	if current_state == "cooldown":
		if cooldown_timer < cooldown:
			cooldown_timer += delta
		elif cooldown_timer >= cooldown:
			current_state = "ready"
			cooldown_timer = 0
			emit_signal("weapon_ready")

func destroyed():
	current_state = "destroyed"