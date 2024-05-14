extends HBoxContainer

@onready var card_scene = preload("res://scenes/dummy_card.tscn")

var card_hand = []

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
	var needed_discard = len(get_parent().current_discard)

	for card in hand:
		var card_value = get_parent().get_card_info(card).value
		if card_value <= get_parent().discard_value:
			pass
		elif not card_value == -1:
			if card_count.has(card_value):
				card_count[card_value] += 1
			else:
				card_count[card_value] = 1

	var good_count = {}
	for count in card_count:
		if card_count[count] >= needed_discard:
			good_count[count] = card_count[count]
	
	var most_common_card
	var max_count = 0

	for card in good_count:
		var count = card_count[card]
		if count > max_count:
			max_count = count
			most_common_card = card
	
	var arr = hand.filter(func (card: String) -> bool: 
		return get_parent().get_card_info(card).value == most_common_card
	)

	for i in (len(arr) - needed_discard):
		arr.pop_front()

	if not len(arr) == needed_discard:
		return []

	return arr


func start_turn():
	var discard = find_most_common_card(card_hand)
	await get_tree().create_timer(0.25).timeout
	if discard == []:
		get_parent().recieve_pass()
	else:
		get_parent().recieve_discard(discard)
		discard_cards(discard)

## Go through all the cards and see what the greatest amount of the same value is
## Then, find the lowest value of those cards
# ["D2", "H4", "C5", "H7", "C7", "S9", "DQ", "HQ", "SQ", "HK", "CK", "DK"]


## Discard all selected cards
func discard_cards(discarded_cards):
	var index = 0
	for card in discarded_cards:
		card_hand.erase(card)
		get_child(index).queue_free()
		index += 1

