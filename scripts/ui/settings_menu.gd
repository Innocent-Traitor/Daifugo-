extends PanelContainer

# Some of the following game rules use get_node() rather than the $ accessor due to having a number in the name

@onready var language_option = $VBoxContainer/ScrollContainer/VBoxContainer/LanguageContainer/LanguageOption
@onready var term_option = $VBoxContainer/ScrollContainer/VBoxContainer/TermsContainer/TermsOption
@onready var autopass_option = $VBoxContainer/ScrollContainer/VBoxContainer/AutoPassContainer/AutoPassOption
@onready var speed_option = $VBoxContainer/ScrollContainer/VBoxContainer/SpeedContainer/SpeedOption

@onready var spades_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/3SpadesContainer/3SpadesOption")
@onready var skip_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/5SkipContainer/5SkipOption")
@onready var ender_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/8EnderContainer/8EnderOption")
@onready var roundstart_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/RoundStartContainer/RoundStartOption")
@onready var forbidden_option = $VBoxContainer/ScrollContainer/VBoxContainer/ForbiddenContainer/ForbiddenOption.get_popup()

func _ready() -> void:
	# Connecting the MenuButton for forbidden last card and connecting it to _handle_menu_options
	forbidden_option.id_pressed.connect(_handle_menu_options.bind())


#region Game Settings
func _on_language_option_item_selected(index:int) -> void:
	GlobalSettings.global_settings['language'] = language_option.get_item_text(index)

func _on_terms_option_item_selected(index:int) -> void:
	GlobalSettings.global_settings['term_language'] = term_option.get_item_text(index)

func _on_auto_pass_option_toggled(toggled_on:bool) -> void:
	GlobalSettings.global_settings['auto_pass'] = toggled_on

func _on_speed_option_item_selected(index:int) -> void:
	GlobalSettings.global_settings['game_speed'] = index
#endregion

#region Game Rules
func _on_spades_option_toggled(toggled_on:bool) -> void:
	GlobalSettings.game_rules['3_spades'] = toggled_on

func _on_skip_option_toggled(toggled_on:bool) -> void:
	GlobalSettings.game_rules['5_skip'] = toggled_on

func _on_ender_option_toggled(toggled_on:bool) -> void:
	GlobalSettings.game_rules['8_ender'] = toggled_on

func _on_round_start_option_item_selected(index:int) -> void:
	GlobalSettings.game_rules['first_play'] = roundstart_option.get_item_text(index)

func _handle_menu_options(id:int) -> void:
	forbidden_option.toggle_item_checked(id)
	var _bool = forbidden_option.is_item_checked(id)
	match id:
		0: # 3 of Spades
			GlobalSettings.game_rules['forbidden_last']['3_spades'] = _bool
		1: # 2 Value Card
			GlobalSettings.game_rules['forbidden_last']['2_card'] = _bool
		2: # Joker
			GlobalSettings.game_rules['forbidden_last']['joker'] = _bool

func _on_sequence_option_toggled(toggled_on:bool):
	GlobalSettings.game_rules['sequence'] = toggled_on

func _on_miyako_option_toggled(toggled_on:bool):
	GlobalSettings.game_rules['miyako_ochi'] = toggled_on

func _on_revolution_option_toggled(toggled_on:bool):
	GlobalSettings.game_rules['revolution'] = toggled_on
#endregion

func apply_settings_from_save() -> void:
	# Language
	# Terms
	#autopass_option.button_pressed = GlobalSettings.global_settings['auto_pass']
	# Game Speed

	#spades_option.button_pressed = GlobalSettings.game_rules['3_spades']
	#skip_option.button_pressed = GlobalSettings.game_rules['5_skip']
	ender_option.button_pressed = GlobalSettings.game_rules['8_ender']
	# Round Start
	# Forbidden Last