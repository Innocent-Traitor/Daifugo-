extends Control

func _ready():
	AdHandler.load_banner_ad()
	SaveLoadHandler.load_game_settings()
	$VersionLabel.text = "v" + ProjectSettings.get_setting("application/config/version")

## Stats
func _on_stats_button_pressed():
	toggle_main_menu_visibility()
	$StatsContainer.visible = true

func _on_stats_return_button_pressed():
	toggle_main_menu_visibility()
	$StatsContainer.visible = false

## Settings
func _on_settings_button_pressed():
	toggle_main_menu_visibility()
	$SettingsContainer.visible = true

func _on_settings_return_pressed():
	SaveLoadHandler.save_game_settings()
	toggle_main_menu_visibility()
	$SettingsContainer.visible = false

## About
func _on_about_button_pressed():
	toggle_main_menu_visibility()
	$AboutContainer.visible = true
	
func _on_about_return_button_pressed():
	toggle_main_menu_visibility()
	$AboutContainer.visible = false

func _on_license_button_pressed():
	$AboutContainer/MainContainer.visible = false
	$AboutContainer/LicenseContainer.visible = true

func _on_license_return_button_pressed():
	$AboutContainer/MainContainer.visible = true
	$AboutContainer/LicenseContainer.visible = false

func _on_github_button_pressed():
	OS.shell_open("https://github.com/Innocent-Traitor/Daifugo-")

func _on_discord_button_pressed():
	OS.shell_open("https://discord.gg/Cv7hBAK65P")

func _on_privacy_button_pressed():
	OS.shell_open("https://www.moonsoftstudios.com/daifugo/privacy.html")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func toggle_main_menu_visibility() -> void:
	if $MainContainer.visible:
		$MainContainer.visible = false
		$Title.visible = false
		$MainLogo.visible = false
	else:
		$MainContainer.visible = true
		$Title.visible = true
		$MainLogo.visible = true



