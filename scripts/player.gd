extends CharacterBody2D

@export var SPEED = 300
@export var JUMP_VELOCITY = -400
@onready var sprite_2d = $Sprite2D

# these are related to the dash
@onready var dash_timer = $DashTimer
@onready var gpu_particles_2d = $GPUParticles2D
@export var DASH_SPEED = 800
var IS_INPUT_DISABLED = false
@export var DASH_TIME = 0.2
var is_player_dashing = false

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jump_sound = preload("res://assets/sounds/kenney_interfacesounds/Audio/select_001.ogg")

# DEATH-related stuff
@export var DEPTH_CAN_KILL: bool = true
@export var DEATH_DEPTH: int = 0
@onready var animation_player = $AnimationPlayer
@onready var death_particles = $DeathParticles
var is_dying = false
# end of DEATH-related stuff

# Death from falling-related
@export var MAX_PIXEL_SAFE_HEIGHT = 100
@export var can_die_from_fall = true
var max_y_reached_yet
# End of Death from falling-related stuff

func _physics_process(delta):
	if is_dying:
		return
		
	# apply gravity to player, only when not touching the floor
	if not is_on_floor() and not is_player_dashing:
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("dash") and not is_player_dashing:
		velocity.x = DASH_SPEED if sprite_2d.flip_h else -DASH_SPEED
		IS_INPUT_DISABLED = true
		is_player_dashing = true
		dash_timer.start(DASH_TIME)
		gpu_particles_2d.restart()
		
		
	# Allow the player to jump 
	if not IS_INPUT_DISABLED:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			AudioManager.play_sound("player_jump_sound")
			
		
		var direction = Input.get_axis("move_left", "move_right")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = 0
	
	if velocity.x < 0:
		sprite_2d.flip_h = false
	elif velocity.x > 0:
		sprite_2d.flip_h = true
		
	move_and_slide()
	
	verify_death()
	handle_fall()
	
func handle_fall():
	if is_on_floor():
		var fall_height = abs(max_y_reached_yet - position.y)
		
		if fall_height > MAX_PIXEL_SAFE_HEIGHT:
			die()
		else:
			max_y_reached_yet = position.y
	else:
		max_y_reached_yet = min(max_y_reached_yet, position.y)
		
	
func verify_death():
	# check Y coordinate to see if we should die
	if DEPTH_CAN_KILL:
		if position.y >= DEATH_DEPTH:
			die()
	
func die():
	is_dying = true
	animation_player.play("death_animation")
		
func after_death_animation():
	get_tree().reload_current_scene()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.register("player_jump_sound", jump_sound)
	max_y_reached_yet = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dash_timer_timeout():
	is_player_dashing = false
	IS_INPUT_DISABLED = false
	
	velocity.x = 0
