extends CharacterBody2D

@export_category("Movement")
@export var SPEED = 300
@export var JUMP_VELOCITY = -400
@onready var sprite_2d = $Sprite2D

@onready var camera_2d = $Camera2D
var ZOOM_INCREASE = Vector2(.1, .1)

@export_category("Dash")
# these are related to the dash
@onready var dash_timer = $DashTimer
@onready var gpu_particles_2d = $GPUParticles2D
@export var DASH_SPEED = 800
var IS_INPUT_DISABLED = false
@export var DASH_TIME = 0.2
var is_player_dashing = false

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jump_sound = preload("res://assets/sounds/kenney_interfacesounds/Audio/select_001.ogg")

var entity = null

@export_category("Death-related")
@export_subgroup("Death by Y value")
# DEATH-related
@export var CAN_DIE_FROM_DEPTH: bool = true
@export var DEATH_DEPTH: int = -1  # Y value at which player dies. -1 disables it
@onready var animation_player = $AnimationPlayer
@onready var death_particles = $DeathParticles
@export var affected_by_gravity = true
var is_dying = false

# Death by falling related
@export_subgroup("Death by Fall Height")
## Number that determines if the distance fallen is safe or should cause death.
@export var MAX_PIXEL_SAFE_HEIGHT: int = 100
@export var can_die_from_fall = true
var max_y_reached_yet

# Debugging
@export_category("Debugging")
@export var DEBUGGING = true
@onready var marker_measure = $MarkerMeasure
@onready var zoom_level:Vector2 = Vector2(2, 2)

func _physics_process(delta):
	# apply gravity to player, only when not touching the floor
	if is_dying:
		return
			
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
	
	if DEBUGGING:
		handle_process_debugging()
	
func handle_process_debugging():
	if Input.is_action_just_pressed("zoom in"):
		camera_2d.zoom += ZOOM_INCREASE
	elif Input.is_action_just_pressed("zoom out"):
		camera_2d.zoom -= ZOOM_INCREASE
		
func handle_fall():
	if is_on_floor():
		var fall_height = abs(max_y_reached_yet - position.y)
		
		if fall_height > MAX_PIXEL_SAFE_HEIGHT:
			die()
		else:
			max_y_reached_yet = position.y
	else:
		max_y_reached_yet = min(max_y_reached_yet, position.y)  # we use min cause Y decreases upwards
	
func verify_death():
	# check Y
	if CAN_DIE_FROM_DEPTH:
		if position.y >= DEATH_DEPTH:
			die()
	
func die():
	is_dying = true
	IS_INPUT_DISABLED = true
	animation_player.play("death_animation")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.register("player_jump_sound", jump_sound)
	max_y_reached_yet = position.y  # make sure we record the player's initial position
	
	if DEBUGGING:
		marker_measure.end = Vector2(0, MAX_PIXEL_SAFE_HEIGHT)
	else:
		marker_measure.visible = false
		marker_measure.set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dash_timer_timeout():
	is_player_dashing = false
	IS_INPUT_DISABLED = false
	
	velocity.x = 0

func _input(event):
	if event.is_action_pressed("interact") and entity:
#		get_viewport().set_input_as_handled()
		entity.interact()
	
func set_entity(root_node_of_entity):
	entity = root_node_of_entity
	
func after_death_animation():
	get_tree().reload_current_scene()
