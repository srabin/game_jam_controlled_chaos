extends CanvasLayer
@onready var player_one: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/PlayerOne
@onready var player_two: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/PlayerTwo


@onready var tramates: CharacterBody2D = $"../Tramates"
@onready var mentaria: CharacterBody2D = $"../Mentaria"





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tramates_percentage = str(tramates.percentage)
	var mentaria_percentage = str(mentaria.percentage)
	player_one.text = tramates_percentage
	player_two.text = mentaria_percentage
