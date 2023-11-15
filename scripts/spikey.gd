extends CharacterBody2D

var following_body: CharacterBody2D = null
@export var move_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if not following_body:
		return
		
	var direction = (following_body.global_position - global_position).normalized()
	velocity = direction * move_speed
	
	move_and_slide()
	
	var collision_count = get_slide_collision_count()
	
	for each_collision in collision_count:
		var collider = get_slide_collision(each_collision)
		
		var collision_object = collider.get_collider()
		
		if collision_object.has_method("die"):
			collision_object.die()

func _on_player_detector_body_entered(body):
	if body.name == "Player":
		following_body = body


func _on_player_detector_body_exited(body):
	if body.name == "Player":
		following_body = null
