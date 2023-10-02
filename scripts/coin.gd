extends Area2D

@onready var collect_sound = preload("res://assets/sounds/kenney_impactsounds/Audio/footstep_wood_003.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.register("collect_coin", collect_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		print("Collected a coin!")
		queue_free()
		GameState.current_coins += 1
		print(GameState.current_coins)
		
		AudioManager.play_sound("collect_coin")
