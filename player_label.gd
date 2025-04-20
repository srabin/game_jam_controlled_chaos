extends Label

@onready var tramates: CharacterBody2D = $"../../../Tramates"
@onready var mentaria: CharacterBody2D = $"../../../Mentaria"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Player One: 0%"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Player One: %s" %
