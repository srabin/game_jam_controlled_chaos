extends CharacterBody2D

@onready var dash_timer = $DashTimer
@onready var stamina_timer = $StaminaTimer
@onready var dash_lockout_timer = $DashLockoutTimer

# Player Movement
var move_input = Vector2.ZERO

const SPEED = 800.0
const DASH_SPEED = SPEED * 1.6
const DECELERATION_RATE = SPEED * 0.04
const ACCELLERATION_RATE = SPEED * 0.09

# Player State
var state: States = States.IDLE
var stamina = 100.0

enum States {IDLE, DASHING, MOVING, HURTING, FALLING}

const STAMINA_DASH_COST = 25.0


func _on_dash_timer_timeout() -> void:
	state = States.IDLE
	

func _on_stamina_timer_timeout() -> void:
	if stamina < 100.0:
		stamina += 1.0
		stamina_timer.start()
		
func _subtract_stamina() -> void:
	stamina -= STAMINA_DASH_COST
	stamina_timer.start()
		
	
func _process(delta: float) -> void:
	var direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	var player_position = self.position
	look_at(player_position + direction)

	
func _dash(horizontal, vertical, dash):	
	#if stamina > 0.0:
	state = States.DASHING
	dash_timer.start()
	velocity.x = horizontal * DASH_SPEED
	velocity.y = vertical * DASH_SPEED
	#self._subtract_stamina()

func _move(horizontal, vertical):
	state == States.MOVING
	velocity.x = move_toward(velocity.x, horizontal * SPEED, ACCELLERATION_RATE)
	velocity.y = move_toward(velocity.y, vertical * SPEED, ACCELLERATION_RATE)
	
	
func _physics_process(delta: float) -> void:
	var horizontal := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vertical := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var dash := Input.get_action_strength("dash")
	match state:
		States.IDLE:
			self._move(horizontal, vertical)
			if dash:
				self._dash(horizontal, vertical, dash)
		States.DASHING:
			pass
		States.MOVING:
			if horizontal and vertical:
				self._move(horizontal, vertical)
			else:
				state = States.IDLE
			if dash:
				self._dash(horizontal, vertical, dash)
		States.HURTING:
			pass
		States.FALLING:
			pass
	
	velocity.x = move_toward(velocity.x, 0, DECELERATION_RATE)
	velocity.y = move_toward(velocity.y, 0, DECELERATION_RATE)
	

	move_and_slide()
