extends PanelContainer

@onready var language_option = $VBoxContainer/ScrollContainer/VBoxContainer/LanguageContainer/LanguageOption
@onready var term_option = $VBoxContainer/ScrollContainer/VBoxContainer/TermsContainer/TermsOption
@onready var autopass_option = $VBoxContainer/ScrollContainer/VBoxContainer/AutoPassContainer/AutoPassOption
@onready var speed_option = $VBoxContainer/ScrollContainer/VBoxContainer/SpeedContainer/SpeedOption

@onready var spades_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/3SpadesContainer/3SpadesOption")
@onready var skip_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/5SkipContainer/5SkipOption")
@onready var ender_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/8EnderContainer/8EnderOption")
@onready var roundstart_option = get_node("VBoxContainer/ScrollContainer/VBoxContainer/RoundStartContainer/RoundStartOption")

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
#endregion
