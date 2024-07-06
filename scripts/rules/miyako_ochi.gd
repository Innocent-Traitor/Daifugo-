extends Node
class_name MiyakoOchi

var gm

func _init(obj: Node) -> void:
	gm = obj

func _check_rule(_cards : Array) -> bool:
	if len(gm.finished_players) >= 1 or gm.round_number == 1:
		return false

	var rank = gm.get_node("Labels/Player" + str(gm.turn_order) + "/Player" + str(gm.turn_order) + "Label").text
	if rank == "Daifugo":
		return false
		
	return true		

func _do_rule(_cards : Array) -> void:
	pass
	# var player_id = gm.turn_order
	# var player = gm.get_node("Player" + player_id) # The player that caused the Miyako Ochi
	# var daifugo_id 
	# var daifugo # The player that is the daifugo
	# for i in 4:
	# 	if gm.get_node("Player" + gm.turn_order + "Label") == "Daifugo":
	# 		daifugo_id = i
	# 		daifugo = gm.get_node("Player " + str(i))
	# 		break

	

	# gm.display_action_label("Miyako Ochi")
	# await gm.get_tree().create_timer(1).timeout
	# gm.action_label.visible = false
	


	# Got the player that caused the miyako ochi, and the daifugo
	# Set the game handler finished players IAW the miyako ochi rule
	# Remove the cards from the players hand

	
			