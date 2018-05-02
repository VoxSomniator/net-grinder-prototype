extends Spatial

#Holds all the players' tanks, handles their spawning and places the cameras right.
#Also makes it so that if a player joins after the game has started, they spectate.
#	It *might* do that. Might.

#Local network ID
var our_id
#Player tank preload
var player_tank
var player_vtol

func _ready():
	#Get our ID
	our_id = get_tree().get_root().get_node("GameCore").get_our_id()
	#Preload the player tank object for later spawning
	player_tank = preload("res://scenes/Player.tscn")
	player_vtol = preload("res://scenes/Player-VTOL.tscn")

#Called by all peers' Level when all players are synced and ready. Spawns all the tanks.
#Gets the list, which is passed along from the server through a complicated chain lol
func spawn_players(player_list):
	print(String(player_list))
	#For each ID
	for player_id in player_list:
		#Spawn a tank
		var t = player_vtol.instance()
		t.set_network_master(player_id)
		t.name = str(player_id)
		#Move the tank so that the players spawn lined up, and not intersecting
		t.translate(Vector3(8*player_list.find(player_id), 0, 0))
		#Spawn in world
		add_child(t)
