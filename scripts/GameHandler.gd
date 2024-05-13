extends Node


## Whose turn is it right now?
var turn_order : int
## How many passed turns have we had?
var pass_count : int = 0

## Array of the most recently discarded cards
var current_discard : Array = [""]
## Value of the most recently discarded card
var discard_value : int = 1

## List of players that have finished by id
var finished_players : Array = []


func _ready():
	new_round()

func new_round():
	deal_cards()

func new_hand():
	pass_count = 0
	current_discard = [""]
	discard_value = 1
	$DiscardPile.reset_discard()
	rotate_turn()
	
## Deal cards to all players
func deal_cards():
	var dealer = Dealer.new()
	dealer.requested_decks = 1
	dealer.prepare_to_deal(1)
	for i in (dealer.requested_decks * 52 / 4):
		# TODO: Adjust it so for the bots it is in a for loop to better support different amount of bot players
		$Player0.add_card(dealer.undealt_cards.pop_back())
		$Player1.add_card(dealer.undealt_cards.pop_back())
		$Player2.add_card(dealer.undealt_cards.pop_back())
		$Player3.add_card(dealer.undealt_cards.pop_back())
	$Player0.sort_cards()
	$Player0.find_valid_cards()
	$Player1.init_hand()
	$Player2.init_hand()
	$Player3.init_hand()

	turn_order = 0
	get_node("Labels/Player" + str(turn_order) + "/Player" + str(turn_order) + "Name").theme_type_variation = "SelectedPlayerLabel"

## Checks to see if a discard is valid
func is_valid_discard(cards: Array) -> bool:
	var card = get_card_info(cards[0])
	if (not len(cards) == len(current_discard)) and (not current_discard == [""]):
		return false
	
	if not is_card_valid(card):
		print('Invalid Discard from player ' + str(turn_order) + ': ' + str(cards))
		return false
	
	return true

## When a player has discarded a hand
func recieve_discard(cards : Array):
	var card = get_card_info(cards[0])
	if cards.all(func(_card: String) -> bool: return _card == "JR" or _card == "JB"):
		discard_value = 16
	else:
		discard_value = card.value
	current_discard = cards
	$DiscardPile.update_discard(current_discard)
	rotate_turn()
	pass_count = 0

## When a player passes their turn
func recieve_pass():
	$Labels/PassLabel.visible = true
	await get_tree().create_timer(0.1).timeout
	$Labels/PassLabel.visible = false

	pass_count += 1
	# If 3 passes in a row, start a new hand TODO: Set this up for different amount of players
	if pass_count == 3:
		new_hand()
		return

	rotate_turn()

## Start the next player's turn
func rotate_turn():
	get_node("Labels/Player" + str(turn_order) + "/Player" + str(turn_order) + "Name").theme_type_variation = ""
	turn_order = (turn_order + 1) % 4
	if turn_order in finished_players:
		print('finished turn')
		rotate_turn()
		return
		
	get_node("Player" + str(turn_order)).start_turn()
	get_node("Labels/Player" + str(turn_order) + "/Player" + str(turn_order) + "Name").theme_type_variation = "SelectedPlayerLabel"

## Check to see if the card is able to be discarded
func is_card_valid(card_id) -> bool:
	var card = get_card_info(card_id)
	if card.suit == "J":
		return true
	return card.value > discard_value

## Called from a player when they finish their hand
func player_finish_hand(player : int):
	print("Player " + str(player) + " finished their hand")
	var node = get_node("Labels/Player" + str(player) + "Rank")
	match len(finished_players):
		0:
			node.text = 'Daifugo'
		1:
			node.text = 'Fugo'
		2:
			node.text = 'Hinmin'

	node.visible = true	
	finished_players.append(player)

	if len(finished_players) == 3:
		for i in 4:
			if i not in finished_players:
				get_node("Labels/Player" + str(i) + "Rank").text = 'Daihinmin'
				get_node("Labels/Player" + str(i) + "Rank").visible = true

## Returns a dictionary with the card value and suit
func get_card_info(card_id) -> Dictionary:
	var card_info = {}
	if not card_id is Dictionary:
		card_info.value = card_id.substr(1, 1)
		card_info.suit = card_id.substr(0, 1)
	else:
		card_info = card_id

	if card_info.suit == "J":
		card_info.value = -1
	
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

