extends Control

@onready var restart_button: Button = $HBoxContainer/Restart
@onready var quit_button: Button = $HBoxContainer/Quit
@onready var audio_manager: AudioManager = $AudioManager
@onready var fight_track: AudioStreamPlayer2D
var global_scene 

@onready var label: Label = $Label



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animation_player.play("RESET")
	self.hide()
	restart_button.disabled = true
	quit_button.disabled = true
	global_scene = get_node("/root/Globals")

func _on_restart_pressed() -> void:
	get_tree().paused = false
	var end_track = get_node("/root/Globals/EndTrack")
	var fight_track = get_node("/root/Globals/FightTrack")
	fight_track.play()
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func end_game(winner : String)-> void:
	get_tree().paused = true
	var end_track = audio_manager.get_audio_2d("end_track")
	audio_manager.play_audio_2d("end_track")
	label.text = "PLAYER %s WINS!" %winner

	restart_button.disabled = false
	quit_button.disabled = false
	self.show()


func _on_mentaria_player_lost() -> void:
	end_game("ONE")


func _on_tramates_player_lost() -> void:
	end_game("TWO")
	
func _on_mouse_entered() -> void:
	global_scene.get_node("SelectClick").play()
