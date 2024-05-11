class_name Dealer
extends Node

# Spades, Clubs, Diamonds, Hearts
# Diamonds: D3, D4, D5, D6, D7, D8, D9, D10, DJ, DQ, DK, DA, D2
# Hearts: H3, H4, H5, H6, H7, H8, H9, H10, HJ, HQ, HK, HA, H2
# Clubs: C3, C4, C5, C6, C7, C8, C9, C10, CJ, CQ, CK, CA, C2
# Spades: S3, S4, S5, S6, S7, S8, S9, S10, SJ, SQ, SK, SA, S2
# Jokers: JR, JB

const DECK : Array = [
	"D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "DJ", "DQ", "DK", "DA", "D2",
	"H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "HJ", "HQ", "HK", "HA", "H2",
	"C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "CJ", "CQ", "CK", "CA", "C2",
	"S3", "S4", "S5", "S6", "S7", "S8", "S9", "S10", "SJ", "SQ", "SK", "SA", "S2",
	"JR", "JB"
]

@export var requested_decks : int = 1

var undealt_cards : Array = []

# Prepares to deal the cards
# count: number of decks to deal
# returns: an array of cards
func prepare_to_deal(count: int) -> void:
	for i in count:
		undealt_cards.append_array(DECK)
	undealt_cards.shuffle()
	

func get_card() -> String:
	if len(undealt_cards) == 0:
		return "null"
	else:
		return undealt_cards.pop_back()


