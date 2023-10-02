extends Node

@onready var music_audio_stream_player = $MusicAudioStreamPlayer
@onready var sounds_audio_stream_player = $SoundsAudioStreamPlayer

var audio_registry = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func register(name: String, audio: AudioStream, overwrite=false):
	if name not in audio_registry:
		audio_registry[name] = audio
		print("Registered sound: " + name)
	else:
		if overwrite:
			audio_registry[name] = audio
			
func unregister(name: String):
	if name in audio_registry:
		audio_registry.erase(name)
		
func play_sound(name: String):
	var sound = audio_registry.get(name)
	
	if not sound:
		print("Couldn't find sound: " + name)
		return
		
	sounds_audio_stream_player.stream = sound
	sounds_audio_stream_player.play()
	
func play_music(name: String, fade_out: float = 1.0, fade_in: float = 1.0):
	var music = audio_registry.get(name)
	
	if not music:
		print("Couldn't find music: " + name)
		return
	
	
	if music_audio_stream_player.playing:
		var tween = get_tree().create_tween()
		
		tween.tween_property(music_audio_stream_player, "volume_db", -80, fade_out)
		tween.tween_callback(music_audio_stream_player.set_stream.bind(music))
		tween.tween_callback(music_audio_stream_player.play)
		tween.tween_property(music_audio_stream_player, "volume_db", 0, fade_in)
	else:
		music_audio_stream_player.stream = music
		music_audio_stream_player.play()
	
