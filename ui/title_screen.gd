extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/controls.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/settings.tscn")
