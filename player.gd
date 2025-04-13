extends CharacterBody2D

@onready var dash_length_timer = $DashLengthTimer
var is_dashing = false
var move_input = Vector2.ZERO

const SPEED = 400.0
const DASH_SPEED = SPEED * 4
const DECELERATION_RATE = SPEED * 0.03
const ACCELLERATION_RATE = SPEED * 0.18



func _on_dash_length_timer_timeout() -> void:
	is_dashing = false
	
func _process(delta: float) -> void:
	var direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	var player_position = self.position
	look_at(player_position + direction)
	
func _physics_process(delta: float) -> void:
	var horizontal := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vertical := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var dash := Input.get_action_strength("dash")
		
	velocity.x = move_toward(velocity.x, horizontal * SPEED, ACCELLERATION_RATE)
	velocity.y = move_toward(velocity.y, vertical * SPEED, ACCELLERATION_RATE)
		
	if dash and not is_dashing:
		velocity.x = horizontal * DASH_SPEED
		velocity.y = vertical * DASH_SPEED

	velocity.x = move_toward(velocity.x, 0, DECELERATION_RATE)
	velocity.y = move_toward(velocity.y, 0, DECELERATION_RATE)
	

	move_and_slide()
