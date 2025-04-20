extends Control
var global_scene

func _ready():
	global_scene = get_node("/root/Globals")
	var title_track = global_scene.get_node("TitleTrack")
	if not title_track.playing:
		title_track.play()
	

func _on_start_button_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	var fight_track = global_scene.get_node("FightTrack")
	var title_track = global_scene.get_node("TitleTrack")
	title_track.stop()
	if not fight_track.playing:
		fight_track.play()
	get_tree().change_scene_to_file("res://world.tscn")


func _on_controls_button_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	get_tree().change_scene_to_file("res://ui/controls.tscn")


func _on_quit_button_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	get_tree().change_scene_to_file("res://ui/settings.tscn")
	
func _on_mouse_entered() -> void:
	global_scene.get_node("SelectClick").play()
