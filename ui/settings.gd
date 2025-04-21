extends Control
@onready var chaos: HSlider = $MarginContainer/VBoxContainer/MarginContainerChaos/Chaos
@onready var volume: HSlider = $MarginContainer/VBoxContainer/MarginContainerVolume/Volume

var global_scene


func _ready() -> void:
	global_scene = get_node("/root/Globals")
	chaos.value = global_scene.chaos
	volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	
func _on_volume_value_changed(value: float) -> void:
	# 0 to 100 decibels if u don't change valiue
	var target_volume_db =  linear_to_db(value) 
	AudioServer.set_bus_volume_db(0, target_volume_db)
	
func _on_chaos_value_changed(value: float) -> void:
	global_scene.chaos = value


func _on_return_button_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")
	
func _on_mouse_entered() -> void:
	global_scene.get_node("SelectClick").play()
