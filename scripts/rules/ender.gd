extends Node
class_name Ender

var game_handler

func _init(obj: Node) -> void:
	game_handler = obj

func _check_rule(cards : Array) -> bool:
	if game_handler.get_card_info(cards[0]).value == 8:
		return true
	else:
		return false

func _do_rule() -> void:
	game_handler.display_action_label("8 Ender!")
	await game_handler.get_tree().create_timer(1).timeout
	game_handler.pass_count = 0
	game_handler.current_discard = [""]
	game_handler.discard_value = 1
	game_handler.reset_discard()
	game_handler.action_label.visible = false
	game_handler.get_node("Player" + str(game_handler.turn_order)).start_turn()