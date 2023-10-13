@tool
extends Node2D
@onready var line_2d = $Line2D
@onready var start_marker = $StartMarker
@onready var end_marker = $EndMarker

@export var start: Vector2
@export var end: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	start = start_marker.position
	end = end_marker.position
	
	set_line_points()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_line_points()

func set_line_points():
	line_2d.clear_points()
	line_2d.add_point(start)
	line_2d.add_point(end)
	
