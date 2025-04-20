extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = $PanelContainer/VBoxContainer/Resume
@onready var title_screen_button: Button = $"PanelContainer/VBoxContainer/Title Screen"
@onready var quit_button: Button = $PanelContainer/VBoxContainer/Quit

var is_paused = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")
	resume_button.disabled = true
	title_screen_button.disabled = true
	quit_button.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			is_paused = false
			resume()
		else:
			is_paused = true
			pause()


func _on_resume_pressed() -> void:
	resume()



func _on_title_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()

func pause() -> void:
	get_tree().paused = true
	animation_player.play("blur")
	resume_button.disabled = false
	title_screen_button.disabled = false
	quit_button.disabled = false
	
func resume() -> void:
	get_tree().paused = false
	animation_player.play_backwards("blur")
	resume_button.disabled = true
	title_screen_button.disabled = true
	quit_button.disabled = true


func _on_pause_button_pressed() -> void:
	if is_paused:
		print("yahoo")
		is_paused = false
		resume()
	else:
		print("yohoo")
		is_paused = true
		pause()
