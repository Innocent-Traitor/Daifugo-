extends Node
class_name MiyakoOchi

var game_handler

func _init(obj: Node) -> void:
	game_handler = obj

func _check_rule(_cards : Array) -> bool:
	if len(game_handler.finished_players) == 0 or len (game_handler.finished_players) >= 2:
		return false

	var player = game_handler.get_node("Player" + game_handler.turn_order)
	var rank = game_handler.get_node("Player"+ game_handler.turn_order + "Label")
	if (player.get_children == 0) or (player.card_hand == 0):
		if rank == "Daifugo":
			return false
		
	return true		

func _do_rule(_cards : Array) -> void:
	var player_id = game_handler.turn_order
	var player = game_handler.get_node("Player" + player_id) # The player that caused the Miyako Ochi
	var daifugo_id 
	var daifugo # The player that is the daifugo
	for i in 4:
		if game_handler.get_node("Player" + game_handler.turn_order + "Label") == "Daifugo":
			daifugo_id = i
			daifugo = game_handler.get_node("Player " + str(i))
			break

	

	game_handler.display_action_label("Miyako Ochi")
	await game_handler.get_tree().create_timer(1).timeout
	game_handler.action_label.visible = false
	


	# Got the player that caused the miyako ochi, and the daifugo
	# Set the game handler finished players IAW the miyako ochi rule
	# Remove the cards from the players hand

	
			