extends Node

#Current lobby is shitty and just keeps a list of all player IDs.
#Later will have map/gamemode selection, chat, etc.

#Stores a reference to the game_core parent for easier use and legibility
var game_core = null
#Similarly, stores our ID because everything needs that lol
var our_id
#Array containing player IDs, updated by the server whenever it changes
var player_array = []
#Fancy formatted string of player IDs
var player_string

func _ready():
	#First, save the parent into game_core
	game_core = get_parent()
	#Get our ID too.
	our_id = game_core.get_our_id()
	print(our_id)
	#Checks our ID. If we're the server, enables the normally-hidden start button.
	if our_id == 1:
		$PanelContainer/VBoxContainer/StartGame.show()
	#Tells the connection manager that we're loaded and ready etc.
	game_core.state_synced(our_id, "Lobby")

#Called by the server to update the player list, once we're ready and whenever someone joins.
remote func update_list(players):
	player_array = players
	player_string = "Player IDs: "
	#If the player list isn't empty, iterate to add IDs to the string
	if not player_array.empty():
		for p in player_array:
			player_string += str(p)
			player_string += ", "
	#Put this string in the label
	$PanelContainer/VBoxContainer/PlayerList.text = player_string

#Called when the start button is pressed. It's only visible to the host.
func _on_StartGame_pressed():
	#First checks that we're actually the server, to prevent shenanigans
	if game_core.get_our_id() == 1:
#		print("Game starting!")
		Console.writeLine("Game starting!")
		#Tells connectionmanager to start the game
		game_core.launch_game()
