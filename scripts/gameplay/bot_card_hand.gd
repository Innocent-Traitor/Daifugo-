extends HBoxContainer

@onready var card_scene = preload("res://scenes/dummy_card.tscn")

var card_hand = []

## Signal to the game handler that we are trading
signal trade_cards(rank : String, cards : Array)

func add_card(card_id):
	card_hand.append(card_id)

func init_hand():
	for i in len(card_hand):
		var card = card_scene.instantiate()
		add_child(card)

func sort_cards():
	var sorted_cards = card_hand
	sorted_cards.sort_custom(func(a, b):
		var a_value = get_parent().get_card_info(a).value
		var b_value = get_parent().get_card_info(b).value
		return a_value < b_value
	)

## Finds the most common card of the lowest value
## FIXME: This shit fucking sucks
func find_most_common_card(hand: Array) -> Array:
	var card_count = {}
	var needed_discard
	# Figure out how many cards we need to do discard
	if (get_parent().current_discard == [""]):
		needed_discard = 0
	else:
		needed_discard = len(get_parent().current_discard)

	# Count the cards, grouping ones that have the same value
	for card in hand:
		var card_value = get_parent().get_card_info(card).value
		if card_value <= get_parent().discard_value:
			pass
		elif not card_value == -1:
			if card_count.has(card_value):
				card_count[card_value] += 1
			else:
				card_count[card_value] = 1

	# Find which counts are equal or more than the needed amount of discarded cards
	var good_count = {}
	for count in card_count:
		if card_count[count] >= needed_discard:
			good_count[count] = card_count[count]
	
	var most_common_card
	var max_count = 0
	# Find the most common card with the lowest value
	for card in good_count:
		var count = card_count[card]
		if count > max_count:
			max_count = count
			most_common_card = card
	
	# Get the cards with the value we want from the hand array
	var arr = hand.filter(func (card: String) -> bool: 
		return get_parent().get_card_info(card).value == most_common_card
	)

	# This is if the bot is starting the turn, go ahead and get rid of the most cards you can
	if needed_discard == 0:
		return arr

	# if we have more cards than needed, get rid of ones until we have the right amount
	while (len(arr) > needed_discard):
		arr.pop_front()

	# if for some reason we don't have the right amount, return an empty array
	if not len(arr) == needed_discard:
		return []

	return arr


func start_turn():
	if get_child_count() == 0:
		get_parent().recieve_pass()
	var discard = find_most_common_card(card_hand)
	await get_tree().create_timer(1).timeout

	if discard == []:
		get_parent().recieve_pass()
	else:
		get_parent().recieve_discard(discard)
		discard_cards(discard)
	
	if len(card_hand) == 0:
		var self_name = self.name.substr(6, 1)
		get_parent().player_finish_hand(int(self_name))

## Discard all selected cards
func discard_cards(discarded_cards):
	var index = 0
	for card in discarded_cards:
		card_hand.erase(card)
		get_child(index).queue_free()
		index += 1

func init_trade(rank : String):
	var _trade_cards = []
	match rank:
		'daifugo':
			for i in 2:
				_trade_cards.append(card_hand.pop_front())
		'fugo':
			_trade_cards.append(card_hand.pop_front())
		'hinmin':
			_trade_cards.append(card_hand.pop_back())
		'daihinmin':
			for i in 2:
				_trade_cards.append(card_hand.pop_back())
	
	trade_cards.emit(rank, _trade_cards)
