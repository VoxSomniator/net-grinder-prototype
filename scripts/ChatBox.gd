extends PanelContainer

#The chat box thing?? Uh oh.
#Used in lobby, and shrunk down in games.

#This early prototype is very simple. Keeps an array of the last hundred or so messages,
#with the username appended, and a bbcode break after each.
#The text box has autoscroll so it should work?
#Does its own networking since the server doesn't matter hooray

#Max messages to store
const LOG_SIZE = 100

#Array of formatted messages
var messages = []
#Our ID, used like the username
var our_id

func _ready():
	#Get our ID from the root node
	our_id = get_tree().get_root().get_node("GameCore").get_our_id()


#Called whenever the user hits enter with textbox selected
func _on_EntryBox_text_entered( new_text ):
	#If the box is empty it won't actually do anything with it.
	if new_text.empty():
		return
	#If there's a message, send it to everyone, including ourselves
	else:
		rpc("update_chat", new_text, our_id)
		#Then, clear the text box for the next message.
		$VBoxContainer/EntryBox.text = ""

#When called, *all peers* receive the new message to add to their array. Then, updates the display.
#Currently it just takes the raw text string, which would theoretically let people fuck it up with escape sequences.
sync func update_chat( new_text, sender_id ):
	#Format the new message: "id: message (line break)"
	var message_string = String(sender_id)
	message_string += ": "
	message_string += new_text
	message_string += "\n"
	
	#Add the new message to the end of the array. If the array goes over the limit, trim it.
	messages.append(message_string)
	if messages.size() > LOG_SIZE:
		for i in range(messages.size()-LOG_SIZE):
			messages.remove(0)
	
	#Print the array to the text box. This is a horribly inefficient way to do this but it's
	#the first way I thought of lol, in the future make it just append the new messages
	#First clear the current text:
	$VBoxContainer/PanelContainer/MessageBox.text = ""
	for i in messages:
		$VBoxContainer/PanelContainer/MessageBox.text += i
	
	#Should work!
	