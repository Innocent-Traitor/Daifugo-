extends Control

func _ready():
	AdHandler.load_banner_ad()

func _on_stats_button_pressed():
	$MainContainer.visible = false
	$StatsContainer.visible = true

func _on_stats_return_button_pressed():
	$MainContainer.visible = true
	$StatsContainer.visible = false

func _on_settings_button_pressed():
	pass # Replace with function body.

func _on_about_button_pressed():
	$MainContainer.visible = false
	$AboutContainer.visible = true
	
func _on_about_return_button_pressed():
	$AboutContainer.visible = false
	$MainContainer.visible = true

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
