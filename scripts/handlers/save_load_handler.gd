extends Node

func save_game_settings() -> void:
    var saved_game_settings = SavedGameSettings.new()
    saved_game_settings.global_settings = GlobalSettings.global_settings
    saved_game_settings.game_rules = GlobalSettings.game_rules
    ResourceSaver.save(saved_game_settings, "user://saved_game_settings.tres")


func load_game_settings() -> void:
    if ResourceLoader.exists("user://saved_game_settings.tres"):
        var saved_game_settings = SafeResourceLoader.load("user://saved_game_settings.tres")
        GlobalSettings.global_settings = saved_game_settings.global_settings
        GlobalSettings.game_rules = saved_game_settings.game_rules
        get_tree().current_scene.get_node("SettingsContainer").apply_settings_from_save()
