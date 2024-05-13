extends HBoxContainer

@onready var card_scene = preload("res://scenes/card.tscn")

var selected_cards = []
var selected_card_value = 0

## Add a card to the hand, and connect the select signals
func add_card(card_id):
	var new_card = card_scene.instantiate()
	new_card.card_id = card_id
	new_card.connect("card_selected", Callable(self, "on_card_selected"))
	new_card.connect("card_unselected", Callable(self, "on_card_unselected"))
	add_child(new_card)

## Sort the cards based off their value TODO: Sort by suit after value
func sort_cards():
	var sorted_cards = get_children()
	sorted_cards.sort_custom(func(a, b): return a.card_value < b.card_value)

	# Add jokers to the end
	for card in sorted_cards:
		if card.card_value == -1:
			sorted_cards.erase(card)
			sorted_cards.append(card)
	
	for node in get_children():
		remove_child(node)

	for node in sorted_cards:
		add_child(node)


func on_card_selected(card_id):
	var card = %GameHandler.get_card_info(card_id)
	if selected_cards.is_empty():
		selected_card_value = card.value
	
	if selected_card_value == -1:
		selected_cards.append(card_id)
		get_node(card_id).select()
		selected_card_value = card.value
		return
	
	if card.value == selected_card_value or card.suit == "J":
		selected_cards.append(card_id)
		get_node(card_id).select()


func on_card_unselected(card_id):
	if selected_cards.is_empty():
		selected_card_value = 0
	selected_cards.erase(card_id)
	get_node(card_id).deselect()

	if contains_only_jokers():
		selected_card_value = -1

## Find all cards that are able to be discarded and highlight them.
## Returns true if there are any valid cards
func find_valid_cards() -> bool:
	var has_valid = false
	for node in get_children():
		if %GameHandler.is_card_valid(node.card_id):
			node.is_valid = true
			node.modulate = Color(1, 1, 1, 1)
			has_valid = true
		else:
			node.is_valid = false
			node.modulate = Color(0.5, 0.5, 0.5, 1)
	
	return has_valid

## Discard all selected cards if they are a valid discard
func _on_discard_button_pressed():
	if selected_cards.is_empty():
		return

	if not get_parent().is_valid_discard(selected_cards):
		return

	for card in selected_cards:
		var card_node = get_node(card)
		remove_child(card_node)
		card_node.queue_free()
	
	end_turn()


func _on_pass_button_pressed():
	# Unselect all cards when passing
	for i in len(selected_cards):
		on_card_unselected(selected_cards[i])
	get_parent().recieve_pass()
	end_turn()


func start_turn():
	find_valid_cards()
	get_node("%DiscardButton").disabled = false
	get_node("%PassButton").disabled = false


func end_turn():
	if not selected_cards.is_empty():
		get_parent().recieve_discard(selected_cards)

	selected_cards = []
	selected_card_value = 0

	if get_child_count() == 0:
		var self_name = self.name.substr(6, 1)
		get_parent().player_finish_hand(int(self_name))

	for node in get_children():
		node.is_valid = false
		node.modulate = Color(0.5, 0.5, 0.5, 1)

	get_node("%DiscardButton").disabled = true
	get_node("%PassButton").disabled = true

## Checks to see if it's only jokers in the selected cards
func contains_only_jokers() -> bool:
	return selected_cards.all(func(_card: String) -> bool: return _card == "JR" or _card == "JB")
