extends Node
#This script runs throughout the whole game, in the GameCore node.
#Holds the core connection code, basic client/server stuff. Both at once. It's very cool.

const PORT = 1234 #Network port
var players = [] #Array of all current player IDs
var our_id #Current instance's network idea

#The game's current state (local). Holds a string with the current state's name. Don't fuck it up.
var current_state

signal new_player(new_id) #Emitted on all peers whenever a new player joins, after registerign is done
signal lost_player(old_id) #Emitted when a peer disconnects


func _ready():
	#Connect built-in networking node signals to our methods
	#	Called whenever a player connects- Other players receive this signal too
	get_tree().connect("network_peer_connected", self, "_player_connected")
	#	Called on clients after their successful connection.
	get_tree().connect("connected_to_server", self, "_connected_ok")
	#	Called whenever a player disconnects- Server and other players receive.
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	#Set up the "server screen" game state
	start_server_screen()


#Called by the initial ServerScreen's "host" button
func on_host_game():
	var host = NetworkedMultiplayerENet.new() #Makes "host" a new network object
	host.create_server(PORT, 16) #Makes a server that starts listening on port, with 16 max connections
	#Tells the scenetree (whole game's root thingy) that "host" is the network object we're using. 
	#This makes it send node signal message things to the right place apparently?
	get_tree().set_network_peer(host)
	our_id = get_tree().get_network_unique_id()
	#Add id 1 to the player list, since server operates as a player too
	players.append(our_id)
	#This is called because the server also runs a player, so the host doesn't need to launch two copies.
	_connected_ok()
	#Starts up the lobby scene
	start_lobby()
	
#Called by serverscreen's join button
func on_join_game(ip):
	#Mostly similar to host_game's stuff- Just connects to a server instead of starting one.
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, PORT)
	get_tree().set_network_peer(host)
	our_id = get_tree().get_network_unique_id()
	


#Signal methods

#Called on client after it connects okay. Called via "connected_to_server" signal.
func _connected_ok():
#	print("Connected to server!")
	Console.writeLine('Connected to server!')
	#Calls the "register player" method on *all peers*.
	rpc("register_player", our_id)
	
#Called on all peers when another peer connects, as soon as they're connected, via signals
func _player_connected(new_id):
	#Doesn't actually do anything yet...
	pass
	
func _player_disconnected(old_id):
	#If we're the server, this removes the disconnected player from userlist.
	if our_id == 1:
		players.erase(old_id)
		#If we're the server in the lobby and someone disconnects, update all the userlists
		if current_state == "Lobby":
			rpc("update_lobby_list", players)
	emit_signal("lost_player", old_id)


#Other information/networking methods

#Called by players when they initially connect.
#Adds them to the list. Will do more later I guess.
remote func register_player(player_id):
	#Run this segment only if we're the server, ID 1
	if our_id == 1:
		#Add the received ID to the list. Only the server tracks this!
		players.append(player_id)
		#Syncs the new player's game state to that of the server- State stuff is below
		rpc_id(player_id, "sync_state", current_state)
	#Whenever a new player joins, after they're registered, all clients emit this signal
	emit_signal("new_player", player_id)

#Called on state-synced players to give them the right lobby list. Sends it to the lobby.
sync func update_lobby_list(player_list):
	get_node("Lobby").update_list(player_list)

#Called by the server's lobby, onto the server. Runs all peers' "start game" state methods.
#start_game() is a sync function.
func launch_game():
	rpc("start_game")

#Returns this client's ID, so other scripts can see that.
func get_our_id():
	return our_id

#Returns the list of players. If called from a client, it calls the server.
remote func get_player_list():
	if our_id == 1:
		return players

#GAME STATE MANAGER- For now, tracks whether we're in the server menu, lobby, or game. Very simple state machine.
#The game's whole scene is never actually unloaded- The same root always remains, with scenes added or removed.
#This is a weird way to do it, but completely unloading the scene may interrupt the network!
#This means we can store data in the root node and it'll remain throughout the game though.

#Holds the preload scene thing for the current part of the game, for loading/instancing
var state_scene = null
#An array of scene names that are used for main game parts like this. Mainly used for clearing the game-
#Resetting will delete any current scenes that match these names to clear out for the new state.
#In the same order as enums.
var all_state_scenes = ["ServerScreen", "Lobby", "Game"]


#Sets state to server screen. Called on game's start (once GameCore loads), and after disconnecting to reset.
func start_server_screen():
	current_state = "ServerScreen"
	state_scene = preload("res://scenes/ServerScreen.tscn")
	#Clears out the tree- This only actually does stuff if the game is already running, to reset.
	clean_tree()
	#Spawns the current state_scene, in this case, the ServerScreen.
	var load_node = state_scene.instance()
	add_child(load_node)
	
#Sets state to lobby. Called once player hits join or host.
func start_lobby():
	#If we're not currently on the server screen, we shouldn't really be entering the lobby, someone goofed
	if current_state != "ServerScreen":
		return
	#If we are currently in the server screen, the lobby is starting normally.
	else:
		current_state = "Lobby"
		state_scene = preload("res://scenes/Lobby.tscn")
		clean_tree()
		var load_node = state_scene.instance()
		#Order of the above three lines is a little important- Preloading can take some time (reading from disk),
		#and clearing the tree before preload is done could leave the player with a blank screen while it loads.
		#Reset the "synced users" list to get ready for loading lobbies
		reset_sync_list()
		add_child(load_node)
		#The lobby "state synced" call isn't made here- It happens in the lobby code, after it *actually loads*.
		
#Sets state to Game. Called once the server hits start.
#This is a sync function because it'll go off for everyone at once at server command.
sync func start_game():
	#If we're not currently in the lobby, something is very wrong
	if current_state != "Lobby":
		return
	#If we're in the lobby, the game is starting as intended.
	else:
		#Mostly the same as the lobby start code up there. Just ordered different.
		current_state = "Game"
		state_scene = preload("res://scenes/maps/citymap2.tscn")
		clean_tree()
		var load_node = state_scene.instance()
		#Reset the sync list. This function only actually does stuff for the server.
		reset_sync_list()
		add_child(load_node)
		GameState.game_state = 1
		


#Helper method called before changing states.
#Clears out any currently-loaded game state scenes, leaves everything else there.
func clean_tree():
	#Gets an array of currently-loaded nodes under the GameCore
	var loaded_nodes = get_children()
	#Removes any loaded nodes that match our game state scenes, and removes those.
	#We don't want to just remove all nodes, there may be other data-storage objects loaded!
	for node in loaded_nodes:
		if all_state_scenes.has(node.name):
			#Deletes the node if its name is in the state list
			node.queue_free()
	#Please note- This is very likely to be broken and cause some problems :B
	
#Called on clients by the server after they're done connecting.
#Tells them the current game state so they can load it.
remote func sync_state(syncing_state):
	#If we're being synced to the lobby
	if syncing_state == "Lobby":
		start_lobby()
	


#State behavior segment- Used by the server to do the right stuff once players have loaded in.

#Array that holds currently-synced players for iterative actions.
#Only used by server. Reset every time the scene changes, then players are added as they load/sync.
#Usefully, "1" is added for the server's "player".
var synced_players = []

#Called by clients on the server to let it know they've prepared the current state.
#Used as a message that the client is ready to receive info.
#Clients call this on their local copy, so if it's called by a non-server instance,
# it'll just conveniently call the server.
remote func state_synced(synced_id, finished_state):
	#If we're the server, do all the management stuff
	if our_id == 1:
		#Lobby syncing
		if current_state == "Lobby":
			#Checks to make sure the client is actually on lobby too.
			#If the client synced to the wrong state, it corrects it.
			if finished_state == "Lobby":
				#Player synced to lobby.
				#Add it to the synced players list.
				synced_players.append(synced_id)
				#Send the new userlist (with all the players) to everyone.
				#Sends it to -everyone-, not just the new player, to update old lists.
				#Also, this uses a Sync function, so this call hits all clients + the server.
				rpc("update_lobby_list", players)
			#Weird possible edge case that could happen if a client loads the game before the server.
			#Not sure how to fix it yet so it'll just let us know if this actually happens lol
			if finished_state == "Game":
#				print("Oops, wrong client/server load order")
				Console.writeLine('Oops, wrong client/server load oerder')
			else:
				pass#Later, this will correct the client's janked state
		
		#Game start syncing
		if current_state == "Game":
			if finished_state == "Game":
				#Add the player who just loaded to the sync list
				synced_players.append(synced_id)
				#Next, once all players are synced, server calls its PlayerSpawner
				#	which calls all the other players' spawners to load the tanks in
				if check_arrays(synced_players, players):
					get_node("Level").all_players_ready(players)
				
	#If we're the client, call the server instead.
	else:
		rpc_id(1, "state_synced", our_id, finished_state)
	

#Minor helper function. Called by state-switching stuff to empty the synced user list.
#Only goes off if it's being called in the server.
func reset_sync_list():
	if our_id == 1:
		synced_players.clear()
		

#Another helper function. Returns true if the first array contains all data the second has.
#Ignores order, and excess in the first.
func check_arrays(first, second):
	var contains = true
	for element in second:
		if not first.has(element):
			contains = false
	return contains
		
		
#func _process(delta):
#	if our_id == 1:
#		print(synced_players)