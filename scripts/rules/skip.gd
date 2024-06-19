extends Node
class_name Skip

var game_handler

func _init(obj: Node) -> void:
	game_handler = obj

func _check_rule(cards : Array) -> bool:
	if game_handler.get_card_info(cards[0]).value == 5:
		return true
	else:
		return false

func _do_rule(cards) -> void:
	game_handler.display_action_label("5 Skip")
	await game_handler.get_tree().create_timer(1).timeout
	game_handler.action_label.visible = false
	game_handler.discard_value = 5
	game_handler.get_node("Labels/Player" + str(game_handler.turn_order) + "/Player" + str(game_handler.turn_order) + "Name").theme_type_variation = ""
	game_handler.turn_order = (game_handler.turn_order + 1) % 4
	await game_handler.get_tree().create_timer(0.25).timeout
	for i in len(cards):
		game_handler.get_node("Labels/Player" + str(game_handler.turn_order) + "/Player" + str(game_handler.turn_order) + "Name").theme_type_variation = ""
		game_handler.get_node("Labels/PassLabel").visible = true
		await game_handler.get_tree().create_timer(0.25).timeout
		game_handler.get_node("Labels/PassLabel").visible = false
		game_handler.pass_count += 1
		game_handler.turn_order = (game_handler.turn_order + 1) % 4
		game_handler.get_node("Labels/Player" + str(game_handler.turn_order) + "/Player" + str(game_handler.turn_order) + "Name").theme_type_variation = "SelectedPlayerLabel"
		if i == 2:
			game_handler.turn_order = (game_handler.turn_order - 1) % 4
			game_handler.new_hand()
			return

	
	game_handler.get_node("Player" + str(game_handler.turn_order)).start_turn()