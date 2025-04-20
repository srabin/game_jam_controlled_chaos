extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = $PanelContainer/VBoxContainer/Resume
@onready var title_screen_button: Button = $"PanelContainer/VBoxContainer/Title Screen"
@onready var quit_button: Button = $PanelContainer/VBoxContainer/Quit
var global_scene 

var is_paused = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")
	resume_button.disabled = true
	title_screen_button.disabled = true
	quit_button.disabled = true
	global_scene = get_node("/root/Globals")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			resume()
		else:
			pause()
			


func _on_resume_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	resume()



func _on_title_screen_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	global_scene.get_node("FightTrack").stop()
	resume()
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")



func _on_quit_pressed() -> void:
	global_scene.get_node("SelectBeep").play()
	get_tree().quit()

func pause() -> void:
	is_paused = true
	get_tree().paused = true
	animation_player.play("blur")
	resume_button.disabled = false
	title_screen_button.disabled = false
	quit_button.disabled = false
	
func resume() -> void:
	is_paused = false
	get_tree().paused = false
	animation_player.play_backwards("blur")
	resume_button.disabled = true
	title_screen_button.disabled = true
	quit_button.disabled = true


func _on_pause_button_pressed() -> void:
	if is_paused:
		is_paused = false
		resume()
	else:
		is_paused = true
		pause()
		
func _on_mouse_entered() -> void:
	if is_paused:
		global_scene.get_node("SelectClick").play()
