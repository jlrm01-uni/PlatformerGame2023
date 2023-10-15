extends Node2D
@onready var line_2d = $Line2D
@onready var start_marker = $StartMarker
@onready var end_marker = $EndMarker
@onready var label = $Label
@export var start_node_path: NodePath
@export var end_node_path: NodePath

var start_node
var end_node

var LABEL_X_OFFSET = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	if not start_node_path and not end_node_path:
		start_node = start_marker
		end_node = end_marker
	else:
		start_node = get_node(start_node_path)
		end_node = get_node(end_node_path)
		
#	set_line_points()

func set_start(position: Vector2):
	start_marker.position = position
	
func set_end(position: Vector2):
	start_marker.position = position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_line_points()
	pass

func set_line_points():
	line_2d.clear_points()
	var center_point: Vector2
	
	line_2d.add_point(start_node.global_position)
	line_2d.add_point(end_node.global_position)
	
#	center_point = start_node.position.lerp(end_node.position, .5)
#
#	label.position = Vector2(center_point.x + LABEL_X_OFFSET, center_point.y)
#	var distance = start_node.position.distance_to(end_node.position)
#	label.text = str(distance)
