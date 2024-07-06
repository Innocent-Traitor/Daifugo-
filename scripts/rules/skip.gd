extends Node
class_name Skip

var gm

func _init(obj: Node) -> void:
	gm = obj

func _check_rule(cards : Array) -> bool:
	if gm.get_card_info(cards[0]).value == 5:
		return true
	else:
		return false

func _do_rule(cards) -> void:
	gm.display_action_label("5 Skip")
	await gm.get_tree().create_timer(1).timeout
	gm.action_label.visible = false
	gm.discard_value = 5
	gm.get_node("Labels/Player" + str(gm.turn_order) + "/Player" + str(gm.turn_order) + "Name").theme_type_variation = ""
	gm.turn_order = (gm.turn_order + 1) % 4
	await gm.get_tree().create_timer(0.25).timeout
	for i in len(cards):
		gm.get_node("Labels/Player" + str(gm.turn_order) + "/Player" + str(gm.turn_order) + "Name").theme_type_variation = ""
		gm.get_node("Labels/PassLabel").visible = true
		await gm.get_tree().create_timer(0.25).timeout
		gm.get_node("Labels/PassLabel").visible = false
		gm.pass_count += 1
		gm.turn_order = (gm.turn_order + 1) % 4
		gm.get_node("Labels/Player" + str(gm.turn_order) + "/Player" + str(gm.turn_order) + "Name").theme_type_variation = "SelectedPlayerLabel"
		if i == 2:
			gm.turn_order = (gm.turn_order - 1) % 4
			gm.new_hand()
			return

	
	gm.get_node("Player" + str(gm.turn_order)).start_turn()