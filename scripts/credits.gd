extends Control

@onready var scroll_container = $PanelContainer/ScrollContainer
@export_file("*.tscn") var after_credits_scene = "res://menu.tscn"

var SPEED = 50
var total = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("animate")

func animate():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if (scroll_container.scroll_vertical + scroll_container.size.y) < scroll_container.get_v_scroll_bar().max_value:
		total += SPEED * delta
		
		scroll_container.scroll_vertical = int(total)

		prints(scroll_container.scroll_vertical, scroll_container.get_v_scroll_bar().max_value)
	else:
		set_process(false)
		FadeScreen.transition_to(after_credits_scene)
		
