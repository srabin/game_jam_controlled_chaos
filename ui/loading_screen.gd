extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(0.5).timeout.connect(hide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
