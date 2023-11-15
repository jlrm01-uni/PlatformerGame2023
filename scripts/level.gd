extends Node2D

@onready var number_of_coins = $CanvasLayer/MarginContainer/HBoxContainer/NumberOfCoins
@export var level_music: AudioStream
@onready var lives = $CanvasLayer/MarginContainer/HBoxContainer/Lives

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_music:
		AudioManager.register("level_music", level_music)
		AudioManager.play_music("level_music")
	else:
		print("Se te olvidó poner la canción del nivel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	number_of_coins.text = str(GameState.current_coins)
	lives.text = str(GameState.lives)
