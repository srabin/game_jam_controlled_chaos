extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var light_attack_sound: AudioStreamPlayer2D = $LightAttack
@onready var on_hit_sound: AudioStreamPlayer2D = $OnHit
@onready var on_block_sound: AudioStreamPlayer2D = $OnBlock
@onready var dash_sound: AudioStreamPlayer2D = $Dash
@onready var spore_splatter: CPUParticles2D = $SporeSplatter

# @export is customizable for each player-instance
@export var player_id : int = 0
@export var attack_animation_speed : float = 2.0
@export var dash_animation_speed : float = 2.0
@export var block_animation_speed : float = 0.4
@export var knockback_modifier : float = 10.0
@export var knockback_limit : float = 180.0

signal player_lost

# Player Movement
var move_input := Vector2.ZERO

const SPEED = 500.0
const DASH_SPEED = SPEED * 2.3
const DECELERATION_RATE = SPEED * 0.04
const ACCELLERATION_RATE = SPEED * 0.12
const BOUNCE_STRENGTH = 0.7	
const MAX_FALL_TIME = 1.5
var inertia = 100.0

# Player State
var player_speed: float = SPEED
var player_dash_speed: float = DASH_SPEED
var state: States = States.IDLE
var has_attacked: bool
var has_dashed: bool
var has_blocked: bool
var has_hurt: bool
var has_stunned: bool
var time_falling: float = 0.0
var is_falling = false
var chaos: float = 1.0
var initial_modulate: Color

var percentage := 0.0

enum States {IDLE, DASHING, MOVING, HURTING, ATTACKING, BLOCKING, DEAD, STUNNED}

func block_stun():
	state = States.STUNNED
	animation_player.stop()
	animation_player.play("stunned", 2, 0.4)
	
func take_damage(amount: int, direction, attacker) -> void:
	if not state == States.BLOCKING:
		if percentage < knockback_limit:
			percentage += amount
		state = States.HURTING
		velocity.x = direction.x * (1 + percentage * knockback_modifier)
		velocity.y = direction.y * (1 + percentage * knockback_modifier)
		animation_player.stop()
		on_hit_sound.play()
		animation_player.play("hurt", 2)
		
		spore_splatter.rotation_degrees = rad_to_deg(direction.angle()) 
		spore_splatter.emitting= true
	else:
		attacker.block_stun()
		on_block_sound.play()
		animation_player.stop()
		self._start_idle()
	

func _ready():
	initial_modulate = sprite.get_modulate()
	animation_player.animation_finished.connect(_on_animation_finished)
	var global_scene = get_node("/root/Globals")
	self.chaos = global_scene.chaos + 1.0
	self.player_speed = SPEED * (1.0 + (chaos*2.0/100.0))
	self.player_dash_speed = DASH_SPEED * (1.0 + (chaos*0.5/100.0))
	self.attack_animation_speed *= (1.0 + (chaos*0.5/100.0))
	self.block_animation_speed *= (1.0 + (chaos*0.5/100))
	
func _process(delta: float) -> void:
	var player_position = self.position
	var direction = Input.get_vector("move_left_" + str(player_id), "move_right_" + str(player_id), "move_up_" + str(player_id), "move_down_" + str(player_id))
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
		"stunned":
			has_stunned = true

func _start_move(horizontal, vertical, delta):
	state = States.MOVING
	if (
		animation_player.current_animation == "idle" 
		or animation_player.current_animation == "hurt"
		or animation_player.current_animation == "stunned"
		or not animation_player.is_playing()
	):
		animation_player.play("walk")
	velocity.x = move_toward(velocity.x, horizontal * player_speed, ACCELLERATION_RATE)
	velocity.y = move_toward(velocity.y, vertical * player_speed, ACCELLERATION_RATE)

func _start_block():
	state = States.BLOCKING
	animation_player.stop()
	animation_player.play("block", 2, block_animation_speed)

	
func _start_dash(horizontal, vertical, delta):
	state = States.DASHING	
	var direction = Vector2()
	if horizontal or vertical:
		direction.x = horizontal
		direction.y = vertical
	else:
		rotation = global_transform.get_rotation()
		direction = Vector2(0, 1).rotated(rotation)

	velocity.x = direction.normalized().x * player_dash_speed
	velocity.y = direction.normalized().y * player_dash_speed
	look_at(self.position + direction.rotated(-1*(PI / 2)))
	
	animation_player.stop()
	dash_sound.play()
	animation_player.play("dash", 2, dash_animation_speed)
		
func _start_light_attack():
	state = States.ATTACKING
	animation_player.stop()
	light_attack_sound.play()
	animation_player.play("light_attack", 2, attack_animation_speed) 
	

func _start_idle():
	state = States.IDLE
	if (
		animation_player.current_animation == "walk" 
		or animation_player.current_animation == "hurt" 
		or animation_player.current_animation == "stunned"
		or not animation_player.is_playing()
	):
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
		sprite.modulate = Color.DARK_ORCHID
		time_falling += delta
	else:
		sprite.modulate = initial_modulate
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
				self._start_dash(horizontal, vertical, delta)
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
				self._start_dash(horizontal, vertical, delta)
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
		States.STUNNED:
			if has_stunned:
				self._start_idle()
				has_stunned = false


	
	velocity.x = move_toward(velocity.x, 0, DECELERATION_RATE)
	velocity.y = move_toward(velocity.y, 0, DECELERATION_RATE)
	
	# save the velocity from before move_and_slide finishes to use for the bounce
	#var initial_velocity = velocity
	
	move_and_slide()
	
	# not sure why last slide... but seth said it feels better
	#var collision = get_last_slide_collision()
	#if collision:
		#velocity = initial_velocity.bounce(collision.get_normal())


func _on_platform_body_exited(body: Node2D) -> void:
	body.is_falling = true


func _on_platform_body_entered(body: Node2D) -> void:
	body.is_falling = false

func end_game() -> void:
	self.player_lost.emit()
