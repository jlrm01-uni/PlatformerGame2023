extends Node2D

@onready var sounds_audio_stream_player = $SoundsAudioStreamPlayer
@onready var music_audio_stream_player = $MusicAudioStreamPlayer

var registered_audio = {}

func register(name: String, audio: AudioStream):
	registered_audio[name] = audio
	print("Registered audio: " + name)
	
func play_sound(name: String):
	var current_sound = registered_audio.get(name)
	
	if current_sound:
		sounds_audio_stream_player.stream = current_sound
		sounds_audio_stream_player.play()
	else:
		print("Sound is not registered: " + name)
		print("Make sure the name is written correctly")
	
func play_music(name: String, fade_out: float=1.0, fade_in: float=1.0):
	var current_music = registered_audio.get(name)
	
	if not current_music:
		print("Couldn't find music: " + name)
		return
		
	if music_audio_stream_player.playing:
		var tween = get_tree().create_tween()
		
		tween.tween_property(music_audio_stream_player, 
							 "volume_db", -80, fade_out)
		tween.tween_callback(music_audio_stream_player.set_stream.bind(current_music))
		tween.tween_callback(music_audio_stream_player.play)
		tween.tween_property(music_audio_stream_player, 
							 "volume_db", 0, fade_in)
	else:
		music_audio_stream_player.stream = current_music
		music_audio_stream_player.play()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
