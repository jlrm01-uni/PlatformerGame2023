extends Node2D

@onready var number_of_coins = $CanvasLayer/MarginContainer/HBoxContainer/NumberOfCoins
@export var level_music: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_music:
		SoundAndMusicPlayer.register("level_music", level_music)
		SoundAndMusicPlayer.play_music("level_music")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	number_of_coins.text = str(GameState.current_coins)
