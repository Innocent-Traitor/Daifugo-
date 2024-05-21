extends HBoxContainer

@onready var card_scene = preload("res://scenes/card.tscn")

var selected_cards = []
var selected_card_value = 0

var trading = false
var round_rank = 'heimen'

## Signal to the game handler that we are trading
signal trade_cards(rank : String, cards : Array)

## Add a card to the hand, and connect the select signals
func add_card(card_id):
	if card_id == null:
		print(name, " recieved null card")
		return
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
	while true:
		var card = sorted_cards[0]
		if card.card_value == -1:
			sorted_cards.erase(card)
			sorted_cards.append(card)
		else:
			break
	
	for node in get_children():
		remove_child(node)

	for node in sorted_cards:
		add_child(node)


func on_card_selected(card_id):
	if trading: # Handles start of round trading
		if round_rank == 'fugo' and len(selected_cards) == 1:
			return
		elif round_rank == 'daifugo' and len(selected_cards) == 2:
			return
		
		selected_cards.append(card_id)
		get_node(card_id).select()
		return
			
	# Makes sure we can't select more than 4 cards
	if len(selected_cards) == 4:
		return

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
	for node in get_children():
		node.is_valid = false
		node.modulate = Color(0.5, 0.5, 0.5, 1)
	
	var current_hand = get_children().filter(func(_card: Node) -> bool: return %GameHandler.is_card_valid(_card.card_id))
	for card in current_hand:
		card.is_valid = true
		card.modulate = Color(1, 1, 1, 1)
	## TODO: Set this up so it will check to see if you have the proper amount of cards for the value

	return not current_hand.is_empty()

## Discard all selected cards if they are a valid discard
func _on_discard_button_pressed():
	if selected_cards.is_empty():
		return

	if trading:
		if round_rank == 'daifugo' and len(selected_cards) != 2:
			return
		elif round_rank == 'fugo' and len(selected_cards) != 1:
			return
		else:
			emit_signal("trade_cards", round_rank, selected_cards)

	if not get_parent().is_valid_discard(selected_cards) and not trading:
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
	if not selected_cards.is_empty() and not trading:
		get_parent().recieve_discard(selected_cards)

	selected_cards = []
	selected_card_value = 0

	if get_child_count() == 0 and not trading:
		var self_name = self.name.substr(6, 1)
		get_parent().player_finish_hand(int(self_name))

	for node in get_children():
		node.is_valid = false
		node.modulate = Color(0.5, 0.5, 0.5, 1)

	trading = false
	get_node("%DiscardButton").disabled = true
	get_node("%PassButton").disabled = true

## Checks to see if it's only jokers in the selected cards
func contains_only_jokers() -> bool:
	return selected_cards.all(func(_card: String) -> bool: return _card == "JR" or _card == "JB")

## Trading cards at beginning of round logic
func init_trade(rank : String):
	trading = true
	round_rank = rank
	get_node("%DiscardButton").disabled = false


	var current_hand = get_children()
	var node
	match rank:
		"hinmin":
			selected_cards.append(current_hand[-1].card_id)
			for card in current_hand:
				card.is_valid = false
				card.modulate = Color(0.5, 0.5, 0.5, 1)
			node = get_node(selected_cards[0])
			node.select()
			node.is_valid = false
			node.modulate = Color(1, 1, 1, 1)

		"daihinmin":
			selected_cards.append(current_hand[-1].card_id)
			selected_cards.append(current_hand[-2].card_id)
			for card in current_hand:
				card.is_valid = false
				card.modulate = Color(0.5, 0.5, 0.5, 1)
			for card in selected_cards:
				node = get_node(card)
				node.select()
				node.is_valid = false
				node.modulate = Color(1, 1, 1, 1)
		
		"heimen":
			for card in current_hand:
				card.is_valid = false
				card.modulate = Color(0.5, 0.5, 0.5, 1)

func _ready():
	var objects = [
		{'value': 1, 'name': 'A'},
		{'value': 2, 'name': 'B'},
		{'value': 1, 'name': 'C'},
		{'value': 3, 'name': 'D'},
		{'value': 2, 'name': 'E'},
		{'value': 1, 'name': 'F'},
	]

	var min_count = 2

	var result = []
	var groups = {}
	for obj in objects:
		var value = obj.value
		if value in groups:
			groups[value].append(obj)
		else:
			groups[value] = [obj]
	for group in groups.values():
		if group.size() >= min_count:
			result += group

	var unique_result = result.duplicate(true)
	print(unique_result)
