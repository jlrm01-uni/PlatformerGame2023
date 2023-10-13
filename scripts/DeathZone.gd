extends Area2D

signal should_kill
@export var send_signal_only = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if send_signal_only:
		emit_signal("should_kill", body)
		return
		
	if body.has_method("die"):
		body.die()
