extends CharacterBody2D

@export var SPEED = 300
@export var JUMP_VELOCITY = -400
@export var DASH_SPEED = 800

@onready var sprite_2d = $Sprite2D
@onready var dash_timer = $DashTimer
@onready var gpu_particles_2d = $GPUParticles2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

var IS_INPUT_DISABLED = false
var DASH_TIME = 0.2
var is_player_dashing = false

@export var DASHES_AVAILABLE = 3
@export var MAX_DASHES = 3

func _physics_process(delta):
	# apply gravity to player, only when not touching the floor
	if not is_on_floor() and not is_player_dashing:
		velocity.y += GRAVITY * delta
	
	# reset dashes
	if is_on_floor():
		DASHES_AVAILABLE = MAX_DASHES
		
	if Input.is_action_just_pressed("dash") and not is_player_dashing and DASHES_AVAILABLE:
		velocity.x = DASH_SPEED if sprite_2d.flip_h else -DASH_SPEED
		gpu_particles_2d.process_material.initial_velocity_min = abs(gpu_particles_2d.process_material.initial_velocity_min) if sprite_2d.flip_h else gpu_particles_2d.process_material.initial_velocity_min
		IS_INPUT_DISABLED = true
		is_player_dashing = true
		dash_timer.start(DASH_TIME)
		gpu_particles_2d.restart()
		decrease_dash_amount()
		
	if not IS_INPUT_DISABLED:
		# Allow the player to jump 
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dash_timer_timeout():
	is_player_dashing = false
	IS_INPUT_DISABLED = false
	
	velocity.x = 0

func reset_dashes():
	DASHES_AVAILABLE = MAX_DASHES
	
func decrease_dash_amount(how_many=1):
	var new_value = DASHES_AVAILABLE - how_many
	
	if new_value < 0:
		DASHES_AVAILABLE = 0
	else:
		DASHES_AVAILABLE = new_value
	
func increase_dash_amount(how_many=1):
	var new_value = DASHES_AVAILABLE + how_many
	
	if new_value < MAX_DASHES:
		DASHES_AVAILABLE += 1
		
