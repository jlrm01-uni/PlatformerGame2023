extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func transition_to(scene_name: String):
	var tween = get_tree().create_tween()
	
	tween.tween_callback(animation_player.play.bind("fade_in_or_out"))
	tween.tween_callback(get_tree().change_scene_to_file.bind(scene_name))
	tween.tween_callback(animation_player.play_backwards.bind("fade_in_or_out"))
	
	
	
	
	
	
