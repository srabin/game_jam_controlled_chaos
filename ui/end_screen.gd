extends Control

@onready var restart_button: Button = $HBoxContainer/Restart
@onready var quit_button: Button = $HBoxContainer/Quit


@onready var label: Label = $Label



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animation_player.play("RESET")
	
	self.hide()
	restart_button.disabled = true
	quit_button.disabled = true



func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://world.tscn")
	

func _on_quit_pressed() -> void:
	get_tree().quit()


func end_game(winner : String)-> void:
	get_tree().paused = true
	label.text = "PLAYER %s WINS!" %winner

	restart_button.disabled = false
	quit_button.disabled = false
	self.show()



func _on_mentaria_player_lost() -> void:
	end_game("ONE")



func _on_tramates_player_lost() -> void:
	end_game("TWO")
