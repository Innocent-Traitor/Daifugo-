extends Node
class_name Ender

var gm

func _init(obj: Node) -> void:
	gm = obj

func _check_rule(cards : Array) -> bool:
	if gm.get_card_info(cards[0]).value == 8:
		return true
	else:
		return false

func _do_rule(_cards) -> void:
	gm.display_action_label("8 Ender")
	await gm.get_tree().create_timer(1).timeout
	gm.pass_count = 0
	gm.current_discard = [""]
	gm.discard_value = 1
	gm.reset_discard()
	gm.action_label.visible = false
	# If the round ends, then don't do anything else
	if gm.turn_order == -1:
		gm.call_deferred("rotate_turn")
		return
	if (gm.get_node("Player" + str(gm.turn_order)).get_children().is_empty() 
	or gm.get_node("Player" + str(gm.turn_order)).card_hand == 0):
		gm.call_deferred("rotate_turn")
		return
	gm.get_node("Player" + str(gm.turn_order)).start_turn()