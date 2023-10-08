extends Area2D

@onready var animation_player = $AnimationPlayer
#@export_file("*.dtl") var initial_timeline
@export var timelines: Array[String] = []
@export var cycle_dialog: bool = true
@onready var alert_label = $AlertLabel

var current_timeline = 0
var exhausted_dialog = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.timeline_ended.connect(increase_timeline_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name != "Player":
		return
		
	body.set_entity(self)
	animation_player.play("brighten")
	print("entered")
	

func _on_body_exited(body):
	if body.name != "Player":
		return
	
	body.set_entity(self)
	
	animation_player.play_backwards("brighten")
	print("exited")

func interact():
	if len(timelines) == 0:
		print("You forgot to set a timeline for me! Nothing to say!")
		return
		
	if Dialogic.current_timeline:
		print("timeline already running")
		return
		
	if not exhausted_dialog:
		Dialogic.start(timelines[current_timeline])
	else:
		print("Dialog for this npc has been exhausted. Nothing more to say.")

func increase_timeline_number():
	var value: int
	
	if cycle_dialog:
		value = (current_timeline + 1) % len(timelines)
	else:
		value = current_timeline + 1
	
		if value >= len(timelines):
			exhausted_dialog = true
			set_exhausted_indicator()
			return
		
	current_timeline = value
	print("current timeline: ", current_timeline)
#	Dialogic.start(additional_timelines[value])

func set_exhausted_indicator():
	alert_label.text = ":("
	
