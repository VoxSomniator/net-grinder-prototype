extends Spatial

#The root of the game world. Lot of stuff going on, but it's split up fortunately.

#Our network ID
var our_id
var level_name = "Arctic City"
var game_mode = "Grinder"

func _ready():
	#Get id
	our_id = get_parent().get_our_id()
	#Tell the server that we're synced.
	get_parent().state_synced(our_id, "Game")
	Console.writeLine(\
	"------------------------------\n" + \
	"[color=aqua]" + str(level_name) + " (" + str(game_mode) + ")" + "[/color]\n" + \
	"------------------------------")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#called only on server, once everyone is synced. calls load_players on all peers.
func all_players_ready(player_list):
	rpc("load_players", player_list)

sync func load_players(player_list):
	get_node("PlayerSpawner").spawn_players(player_list)