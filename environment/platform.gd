extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var order_of_animations = ["big", "medium", "small"]
var cur_animation = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if cur_animation <= len(order_of_animations) - 1:
		animation_player.play(order_of_animations[cur_animation])
		cur_animation += 1
