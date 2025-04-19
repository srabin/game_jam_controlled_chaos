extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# @export is customizable for each player-instance
@export var player_id : int = 0
@export var attack_animation_speed : float = 2.0
@export var dash_animation_speed : float = 2.0
@export var block_animation_speed : float = 0.4
@export var knockback_modifier : int = 10.0

# Player Movement
var move_input := Vector2.ZERO

const SPEED = 500.0
const DASH_SPEED = SPEED * 2.3
const DECELERATION_RATE = SPEED * 0.04
const ACCELLERATION_RATE = SPEED * 0.12
const BOUNCE_STRENGTH = 0.7	
const MAX_FALL_TIME = 1.0
var inertia = 100.0

# Player State
var state: States = States.IDLE
var has_attacked: bool
var has_dashed: bool
var has_blocked: bool
var has_hurt: bool
var time_falling: float = 0.0
var is_falling = false

var percentage := 0.0

enum States {IDLE, DASHING, MOVING, HURTING, ATTACKING, BLOCKING, DEAD}

func take_damage(amount: int, direction) -> void:
	if not state == States.BLOCKING:
		percentage += amount
		state = States.HURTING
		velocity.x = direction.x * (1 + percentage * knockback_modifier)
		velocity.y = direction.y * (1 + percentage * knockback_modifier)
		animation_player.stop()
		animation_player.play("hurt", 2)
		animation_player.animation_finished.connect(_on_animation_finished)


	
func _process(delta: float) -> void:
	var direction = Input.get_vector("look_left_" + str(player_id), "look_right_" + str(player_id), "look_up_" + str(player_id), "look_down_" + str(player_id))
	var player_position = self.position
	# This needs to be rotated 90 degrees because look_at looks to the right of the sprite by default
	if state != States.DASHING:
		look_at(player_position + direction.rotated(-1*(PI / 2)))

func _on_animation_finished(_animation):
	match _animation:
		"light_attack":
			has_attacked = true
		"dash":
			has_dashed = true
		"block":
			has_blocked = true 
		"hurt":
			has_hurt = true
			
func _start_move(horizontal, vertical, delta):
	state = States.MOVING
	if animation_player.current_animation == "idle" or not animation_player.is_playing():
		animation_player.play("walk")
	velocity.x = move_toward(velocity.x, horizontal * SPEED, ACCELLERATION_RATE)
	velocity.y = move_toward(velocity.y, vertical * SPEED, ACCELLERATION_RATE)

func _start_block():
	state = States.BLOCKING
	animation_player.stop()
	animation_player.play("block", 2, block_animation_speed)
	animation_player.animation_finished.connect(_on_animation_finished)

	
func _start_dash(horizontal, vertical, dash, delta):
	state = States.DASHING	
	var direction = Vector2()
	if horizontal or vertical:
		direction.x = horizontal
		direction.y = vertical
	else:
		rotation = global_transform.get_rotation()
		direction = Vector2(0, 1).rotated(rotation)

	velocity.x = direction.normalized().x * DASH_SPEED
	velocity.y = direction.normalized().y * DASH_SPEED
	look_at(self.position + direction.rotated(-1*(PI / 2)))
	
	animation_player.stop()
	animation_player.play("dash", 2, dash_animation_speed)
	animation_player.animation_finished.connect(_on_animation_finished)
		
func _start_light_attack():
	state = States.ATTACKING
	animation_player.stop()
	animation_player.play("light_attack", 2, attack_animation_speed) 
	animation_player.animation_finished.connect(_on_animation_finished)
	

func _start_idle():
	state = States.IDLE
	if animation_player.current_animation == "walk" or not animation_player.is_playing():
		animation_player.play("idle")

	
func _physics_process(delta: float) -> void:	
	if self.state == States.DEAD:
		return
		
	var horizontal = Input.get_action_strength("move_right_" + str(player_id)) - Input.get_action_strength("move_left_" + str(player_id))
	var vertical = Input.get_action_strength("move_down_" + str(player_id)) - Input.get_action_strength("move_up_" + str(player_id))
	var dash = Input.is_action_just_pressed("dash_" + str(player_id))
	var light_attack = Input.is_action_just_pressed("light_attack_" + str(player_id))
	var block = Input.is_action_just_pressed("block_" + str(player_id))
	
	if is_falling == true:
		time_falling += delta
	else:
		time_falling = 0.0
		
	#STATE = DEAD
	if time_falling > MAX_FALL_TIME:
		self.animation_player.stop()
		self.animation_player.play("falling", -1, 3)
		self.state = States.DEAD
		#remove collision 
	
	match state:
		States.IDLE:
			if horizontal or vertical:
				self._start_move(horizontal, vertical, delta)
			if dash:
				self._start_dash(horizontal, vertical, dash, delta)
			if light_attack:
				self._start_light_attack()
			if block:
				self._start_block()
		States.MOVING:
			if horizontal or vertical:
				self._start_move(horizontal, vertical, delta)
			else:
				self._start_idle()
			if dash:
				self._start_dash(horizontal, vertical, dash, delta)
			if light_attack:
				self._start_light_attack()
			if block:
				self._start_block()
		States.BLOCKING:
			if has_blocked:
				self._start_idle()
				has_blocked = false
		States.DASHING:
			if has_dashed:
				self._start_idle()
				has_dashed = false
			if light_attack:
				self._start_light_attack()
			if block:
				self._start_block()
		States.ATTACKING:
			if has_attacked:
				self._start_idle()
				has_attacked = false
		States.HURTING:
			if has_hurt:
				self._start_idle()
				has_hurt = false


	
	velocity.x = move_toward(velocity.x, 0, DECELERATION_RATE)
	velocity.y = move_toward(velocity.y, 0, DECELERATION_RATE)
	
	# save the velocity from before move_and_slide finishes to use for the bounce
	var initial_velocity = velocity
	
	move_and_slide()
	
	# not sure why last slide... but seth said it feels better
	#var collision = get_last_slide_collision()
	#if collision:
		#velocity = initial_velocity.bounce(collision.get_normal())


func _on_platform_body_exited(body: Node2D) -> void:
	body.is_falling = true


func _on_platform_body_entered(body: Node2D) -> void:
	body.is_falling = false
