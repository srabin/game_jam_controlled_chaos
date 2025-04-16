extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

# Player Movement
var move_input := Vector2.ZERO

const SPEED = 500.0
const DASH_SPEED = SPEED * 1.6
const DECELERATION_RATE = SPEED * 0.04
const ACCELLERATION_RATE = SPEED * 0.12
const BOUNCE_STRENGTH = 0.7	
var inertia = 100.0

# Player State
var state: States = States.IDLE
var has_attacked: bool
var has_dashed: bool
var has_blocked: bool

var attack_speed := 2.0
var dash_speed := 2.0
var block_speed := 0.4

var percentage := 0.0



enum States {IDLE, DASHING, MOVING, HURTING, FALLING, ATTACKING, BLOCKING}

func take_damage(amount: int) -> void:
	if not state == States.BLOCKING:
		percentage += amount
		print(percentage)

	
func _process(delta: float) -> void:
	var direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	var player_position = self.position
	# This needs to be rotated 90 degrees because look_at looks to the right of the sprite by default
	look_at(player_position + direction.rotated(-1*(PI / 2)))

	
func _dash(horizontal, vertical, dash, delta):	
	state = States.DASHING
	animation_player.play("dash", -1, dash_speed)
	animation_player.animation_finished.connect(func(_animation): has_dashed = true)
	velocity.x = horizontal * DASH_SPEED
	velocity.y = vertical * DASH_SPEED


func _move(horizontal, vertical, delta):
	state = States.MOVING
	if not animation_player.current_animation == "walk" or not animation_player.is_playing():
		animation_player.play("walk")
	velocity.x = move_toward(velocity.x, horizontal * SPEED, ACCELLERATION_RATE)
	velocity.y = move_toward(velocity.y, vertical * SPEED, ACCELLERATION_RATE)

func _light_attack():
	state = States.ATTACKING
	animation_player.play("light_attack", -1, attack_speed)
	animation_player.animation_finished.connect(func(_animation): has_attacked = true)
	
func _block():
	state = States.BLOCKING
	animation_player.play("block", -1, block_speed)
	animation_player.animation_finished.connect(func(_animation): has_blocked = true)
	
func _physics_process(delta: float) -> void:
	var horizontal := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vertical := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var dash := Input.get_action_strength("dash")
	var light_attack := Input.get_action_strength("light_attack")
	var block := Input.get_action_strength("block")

	match state:
		States.IDLE:
			animation_player.play("idle")
			if horizontal or vertical:
				self._move(horizontal, vertical, delta)
			if dash:
				self._dash(horizontal, vertical, dash, delta)
			if light_attack:
				self._light_attack()
			if block:
				self._block()
			
		States.DASHING:
			if has_dashed:
				state = States.IDLE
				has_dashed = false
			if light_attack:
				self._light_attack()
			if block:
				self._block()
		States.MOVING:
			if horizontal or vertical:
				self._move(horizontal, vertical, delta)
			else:
				state = States.IDLE
			if dash:
				self._dash(horizontal, vertical, dash, delta)
			if light_attack:
				self._light_attack()
			if block:
				self._block()
		States.HURTING:
			pass
		States.FALLING:
			pass
		States.ATTACKING:
			if has_attacked:
				state = States.IDLE
				has_attacked = false
		States.BLOCKING:
			if has_blocked:
				state = States.IDLE
				has_blocked = false
	
	velocity.x = move_toward(velocity.x, 0, DECELERATION_RATE)
	velocity.y = move_toward(velocity.y, 0, DECELERATION_RATE)
	
	# save the velocity from before move_and_slide finishes to use for the bounce
	var initial_velocity = velocity
	
	move_and_slide()
	
	# not sure why last slide... but seth said it feels better
	var collision = get_last_slide_collision()
	if collision:
		velocity = initial_velocity.bounce(collision.get_normal())
