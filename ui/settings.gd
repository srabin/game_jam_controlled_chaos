extends Control

func _on_volume_value_changed(value: float) -> void:
	# 0 to 100 decibels if u don't change valiue
	AudioServer.set_bus_volume_db(0, value)
	
func _on_chaos_value_changed(value: float) -> void:
	var global_scene = get_node("/root/Globals")
	global_scene.chaos = value


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")
