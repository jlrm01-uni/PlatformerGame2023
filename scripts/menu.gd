extends Control

@onready var music_audio_stream_player = $MusicAudioStreamPlayer
@onready var sounds_audio_stream_player = $SoundsAudioStreamPlayer
@onready var hover_sound = load("res://assets/sounds/kenney_interfacesounds/Audio/drop_001.ogg")
@onready var play_button_sound = load("res://assets/sounds/kenney_interfacesounds/Audio/error_004.ogg")
@onready var load_button_sound = load("res://assets/sounds/kenney_impactsounds/Audio/footstep_grass_004.ogg")
@onready var pressed_button_sound = load("res://assets/sounds/kenney_interfacesounds/Audio/confirmation_001.ogg")

var sounds: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	sounds = {
		"continue": hover_sound,
		"play": play_button_sound,
		"load": load_button_sound,
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_button_pressed():
	pass # Replace with function body.


func _on_play_button_pressed():
	sounds_audio_stream_player.stream = pressed_button_sound
	sounds_audio_stream_player.play()
	
	await sounds_audio_stream_player.finished
	
	FadeScreen.transition_to("res://levels/level.tscn")


func _on_load_button_pressed():
	get_tree().change_scene_to_file("res://levels/load.tscn")


func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://levels/settings.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://levels/credits.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_continue_button_mouse_entered():
	sounds_audio_stream_player.stream = hover_sound
	sounds_audio_stream_player.play()
	
	
func _on_button_entered(button_name: String):
	var sound_to_use
	
	sound_to_use = sounds.get(button_name, hover_sound)
	
	sounds_audio_stream_player.stream = sound_to_use
	sounds_audio_stream_player.play()
	
