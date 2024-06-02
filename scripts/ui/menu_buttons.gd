extends Control


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_new_button_pressed():
	get_tree().reload_current_scene()
