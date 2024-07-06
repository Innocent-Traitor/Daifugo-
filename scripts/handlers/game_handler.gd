extends Node

@onready var action_label = $Labels/ActionLabel

var round_number = 0

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

## Trade cards at the beginning of a new round
var card_trade = {
	'daifugo' : ["", ""],
	'fugo' : [""],
	'hinmin' : [""],
	'daihinmin' : ["", ""],
}
var recieved_trades = 0

## Current set of rules in play
var current_rules = []
var miyako_ochi

func _ready():
	new_round()
	get_current_rules()

## Set up for a new round
func new_round():
	for i in 4:
		get_node("Labels/Player" + str(i) + "/Player" + str(i) + "Name").theme_type_variation = ""
		get_node("Labels/Player" + str(i) + "Rank").visible = false
	
	$Player1.card_hand = []
	$Player2.card_hand = []
	$Player3.card_hand = []
	reset_discard()
	finished_players = []
		
	if round_number == 0:
		deal_cards()
	else:
		rename_labels()
		deal_cards()
		await get_tree().create_timer(0.5).timeout
		handle_trade()

	round_number += 1

func handle_trade():
	display_action_label("Select cards to trade")
	for i in 4:
		var rank = get_node("Labels/Player" + str(i) + "/Player" + str(i) + "Label").text
		get_node("Player" + str(i)).init_trade(rank.to_lower())

func reset_discard():
	pass_count = 0
	current_discard = [""]
	discard_value = 1
	$DiscardPile.reset_discard()

## Set up for a new hand
func new_hand():
	reset_discard()
	rotate_turn()
	
## Deal cards to all players
func deal_cards():
	var dealer = Dealer.new()
	dealer.requested_decks = 1
	dealer.prepare_to_deal(1)
	var num_of_cards = len(dealer.undealt_cards)
	var index = 0
	for i in (num_of_cards):
		get_node("Player" + str(index)).add_card(dealer.get_card())
		index += 1
		if index > 3:
			index = 0
	for i in 4:
		get_node("Player" + str(i)).sort_cards()
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
	# Update discard pile
	current_discard = cards
	$DiscardPile.update_discard(current_discard)
	pass_count = 0

	# Run the ruleset checks
	for rule in current_rules:
		if rule._check_rule(cards):
			rule._do_rule(cards)
			return

	# If it's all jokers, set the discard value to 16 and then rotate turn
	var card = get_card_info(cards[0])
	if cards.all(func(_card: String) -> bool: return _card == "JR" or _card == "JB"):
		discard_value = 16
	else:
		discard_value = card.value
	call_deferred("rotate_turn")

## When a player passes their turn
func recieve_pass():
	$Labels/PassLabel.visible = true
	await get_tree().create_timer(0.25).timeout
	$Labels/PassLabel.visible = false

	pass_count += 1
	# If 3 passes in a row, start a new hand TODO: Set this up for different amount of players
	if pass_count >= 3:
		new_hand()
		return

	call_deferred("rotate_turn")

## Used to force a pass silently for logic purposes
func silent_pass():
	pass_count += 1
	if pass_count >= 3:
		new_hand()
		return
	call_deferred("rotate_turn")

## Start the next player's turn
func rotate_turn():
	if turn_order == -1:
		await get_tree().create_timer(1).timeout
		new_round()
		return
	get_node("Labels/Player" + str(turn_order) + "/Player" + str(turn_order) + "Name").theme_type_variation = ""
	turn_order = (turn_order + 1) % 4
	if turn_order in finished_players:
		silent_pass()
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
	if miyako_ochi:
		if miyako_ochi._check_rule([]):
			miyako_ochi._do_rule([])
			return
		
		# After the rule is triggered and the next player becomes Fugo
		# Check to see if we have a Daihinmin 

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
				for child in get_node("Player" + str(i)).get_children():
					child.queue_free()
				turn_order = -1

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


func rename_labels():
	for i in 4:
		var rank = get_node("Labels/Player" + str(i) + "Rank")
		get_node("Labels/Player" + str(i) + "/Player" + str(i) + "Label").text = rank.text
		rank.text = "Undefined"

func recieve_trade(rank : String, cards : Array):
	card_trade[rank] = cards
	recieved_trades += 1
	if not recieved_trades == 4:
		return

	for i in 4:
		var player_rank = get_node("Labels/Player" + str(i) + "/Player" + str(i) + "Label").text.to_lower()
		match player_rank:
			'daifugo':
				player_rank = 'daihinmin'
			'fugo':
				player_rank = 'hinmin'
			'hinmin':
				player_rank = 'fugo'
			'daihinmin':
				player_rank = 'daifugo'
		
		for trade in card_trade[player_rank]:
			var player = get_node("Player" + str(i))
			player.add_card(trade)
			player.sort_cards()

	card_trade.clear()
	recieved_trades = 0
	action_label.visible = false
	new_hand()

## Gets all currently selected rules from the player set ruleset
func get_current_rules() -> void:	
	for rule in GlobalSettings.game_rules:
		if GlobalSettings.game_rules[rule]:
			match rule:
				'8_ender':
					current_rules.append(Ender.new(self))
				'5_skip':
					current_rules.append(Skip.new(self))
				'miyako_ochi':
					miyako_ochi = MiyakoOchi.new(self)

func display_action_label(text : String) -> void:
	action_label.text = text
	action_label.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("print_rules"):
		print(GlobalSettings.game_rules)
