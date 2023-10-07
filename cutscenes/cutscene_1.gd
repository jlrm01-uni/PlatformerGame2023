extends Control

@onready var cutscene_music = preload("res://assets/music/Juhani Junkala [Retro Game Music Pack]/Juhani Junkala [Retro Game Music Pack] Ending.wav")
@onready var default_dialog_node = $DefaultDialogNode

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.register("cutscene1_music", cutscene_music)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	Dialogic.start_timeline("timeline")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_cutscene_music():
	AudioManager.play_music("cutscene1_music")
	
func _on_dialogic_timeline_ended():
	default_dialog_node.visible = false
	
