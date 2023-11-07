extends CharacterBody2D

var following_body: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass
	

func _on_player_detector_body_entered(body):
	following_body = body


func _on_player_detector_body_exited(body):
	following_body = null
