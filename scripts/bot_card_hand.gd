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
func find_most_common_card() -> Array:
	var card_count = {}

	for card in card_hand:
		var card_value = get_parent().get_card_info(card).value
		if not card_value == -1:
			if card_count.has(card_value):
				card_count[card_value] += 1
			else:
				card_count[card_value] = 1
	
	var most_common_card = []
	var max_count = 0

	for card in card_count:
		var count = card_count[card]
		if count > max_count:
			max_count = count
			most_common_card = card
	
	var arr = card_hand.filter(func (card: String) -> bool: 
		return get_parent().get_card_info(card).value == most_common_card
	)

	return arr


func start_turn():
	print(find_most_common_card())
	await get_tree().create_timer(0.1).timeout
	get_parent().recieve_pass()

## Go through all the cards and see what the greatest amount of the same value is
## Then, find the lowest value of those cards
# ["D2", "H4", "C5", "H7", "C7", "S9", "DQ", "HQ", "SQ", "HK", "CK", "DK"]


## Discard all selected cards
func discard_cards(discarded_cards):
	for card in discarded_cards:
		get_node(card).queue_free()
