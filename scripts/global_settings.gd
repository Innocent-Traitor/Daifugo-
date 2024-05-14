extends Node

var global_settings = {
	'language' = 'en',
	'term_language' = 'jp',
	'auto_pass' = false,
	'game_speed' = 2, # 0 = instant, 1 = fast, 2 = normal, 3 = slow
	'num_of_players' = 4,
}

var game_rules = {
	'5_skip' = false,
	'8_ender' = false,

	'first_play' = 'daihinmin',
	'forbidden_last' = [],
	'sequence' = false,
	'miyako_ochi' = false
}