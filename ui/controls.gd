extends Control
var global_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_scene = self.get_node("/root/Globals")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")


func _on_mouse_entered() -> void:
	global_scene.get_node("SelectClick").play()
