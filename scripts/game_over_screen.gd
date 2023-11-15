extends Control

@export var music: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	if music:
		AudioManager.register("game_over_music", music)
		AudioManager.play_music("game_over_music")
	else:
		print("Se te olvidó poner la canción del game over")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://levels/level.tscn")


func _on_desktop_button_pressed():
	get_tree().quit()
