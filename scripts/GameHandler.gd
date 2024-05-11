extends Node

# Whose turn is it right now?
var turn_order : int

## Array of the most recently discarded cards
var current_discard : Array = [""]
## Value of the most recently discarded card
var discard_value : int = 1


func _ready():
	new_round()


func new_round():
	deal_cards()

## Deal cards to all players
func deal_cards():
	var dealer = Dealer.new()
	dealer.requested_decks = 1
	dealer.prepare_to_deal(1)
	for i in (dealer.requested_decks * 52 / 4):
		# TODO: Adjust it so for the bots it is in a for loop to better support different amount of bot players
		$PlayerCardHand.add_card(dealer.undealt_cards.pop_back())
		$BotPlayer1.add_card(dealer.undealt_cards.pop_back())
		$BotPlayer2.add_card(dealer.undealt_cards.pop_back())
		$BotPlayer3.add_card(dealer.undealt_cards.pop_back())
	$PlayerCardHand.sort_cards()
	$PlayerCardHand.find_valid_cards()
	$BotPlayer1.init_hand()
	$BotPlayer2.init_hand()
	$BotPlayer3.init_hand()

	turn_order = 0
	get_node("Labels/Player" + str(turn_order) + "/Player" + str(turn_order) + "Name").theme_type_variation = "SelectedPlayerLabel"


## When a player has discarded a hand
func recieve_discard(cards : Array):
	var card = get_card_info(cards[0])
	if not is_card_valid(card):
		print('Invalid Discard from player ' + str(turn_order) + ': ' + str(cards))
		return

	discard_value = card.value
	current_discard = cards
	$DiscardPile.update_discard(current_discard)
	rotate_turn()


func recieve_pass():
	$Labels/PassLabel.visible = true
	await get_tree().create_timer(0.25).timeout
	$Labels/PassLabel.visible = false
	rotate_turn()

## Start the next player's turn
func rotate_turn():
	get_node("Labels/Player" + str(turn_order) + "/Player" + str(turn_order) + "Name").theme_type_variation = ""
	turn_order = (turn_order + 1) % 4
	if turn_order == 0:
		$PlayerCardHand.start_turn()
	else:
		get_node("BotPlayer" + str(turn_order)).start_turn()
		
	get_node("Labels/Player" + str(turn_order) + "/Player" + str(turn_order) + "Name").theme_type_variation = "SelectedPlayerLabel"


## Check to see if the card is able to be discarded
func is_card_valid(card_id) -> bool:
	var card = get_card_info(card_id)
	return card.value > discard_value

# Returns a dictionary with the card value and suit
func get_card_info(card_id) -> Dictionary:
	var card_info = {}
	if not card_id is Dictionary:
		card_info.value = card_id.substr(1, 1)
		card_info.suit = card_id.substr(0, 1)
	else:
		card_info = card_id

	if card_info.suit == "J":
		print("Joker")
	
	match card_info.value:
		"1":
			card_info.value = 10
		"J":
			card_info.value = 11
		"Q":
			card_info.value = 12
		"K":
			card_info.value = 13
		"A":
			card_info.value = 14
		"2":
			card_info.value = 15
		_:
			card_info.value = int(card_info.value)
	return card_info

