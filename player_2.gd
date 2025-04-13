extends CharacterBody2D

@onready var dash_length_timer = $DashLengthTimer
var is_dashing = false

const SPEED = 800.0
const DASH_SPEED = SPEED * 5
const DECELERATION_RATE = SPEED * 0.04
const ACCELLERATION_RATE = SPEED * 0.18


func _on_dash_length_timer_timeout() -> void:
	is_dashing = false
	#velocity.x = move_toward(velocity.x, 0, DECELERATION_RATE)
	#velocity.y = move_toward(velocity.y, 0, DECELERATION_RATE)
	#velocity.x = 0
	#velocity.y = 0
	
func _process(delta: float) -> void:
	var horizontal = Input.get_axis("move_left_2", "move_right_2")
	var vertical = Input.get_axis("move_up_2", "move_down_2")
	look_at(Vector2(horizontal, vertical))
	
func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("move_left_2", "move_right_2")
	var vertical := Input.get_axis("move_up_2", "move_down_2")
	var dash := Input.is_action_just_pressed("dash")
		
	#if not is_dashing:
	velocity.x = move_toward(velocity.x, horizontal * SPEED, ACCELLERATION_RATE)
		
	#if not is_dashing:
	velocity.y = move_toward(velocity.y, vertical * SPEED, ACCELLERATION_RATE)
		
	if dash and not is_dashing:
		#dash_length_timer.start()
		#is_dashing = true
		#var click_position = get_global_mouse_position()
		#var target_position = (click_position - position).normalized()
		#velocity = target_position * DASH_SPEED
		velocity.x = horizontal * DASH_SPEED
		velocity.y = vertical * DASH_SPEED

	velocity.x = move_toward(velocity.x, 0, DECELERATION_RATE)
	velocity.y = move_toward(velocity.y, 0, DECELERATION_RATE)
	

	move_and_slide()
