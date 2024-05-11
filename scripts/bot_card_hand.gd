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
	sorted_cards.sort_custom(func(a, b): return a.card_value < b.card_value)


func start_turn():
	await get_tree().create_timer(0.25).timeout
	get_parent().recieve_pass()


## Discard all selected cards
func discard_cards(discarded_cards):
	for card in discarded_cards:
		get_node(card).queue_free()
