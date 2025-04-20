extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var order_of_animations = ["medium", "small"]
var cur_animation = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if cur_animation <= len(order_of_animations) - 1:
		animation_player.play(order_of_animations[cur_animation], -1, 0.5)
		cur_animation += 1
