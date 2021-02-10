extends Area2D
var dir = Vector2.ZERO
var mspeed = 25.5

# Called when the node enters the scene tree for the first time.
func ready_pos(pos, input):
	dir = input	
	position = pos

func _physics_process(_delta):
	position = position + dir * mspeed
	pass 

func _on_killself_timeout():
	queue_free()
	pass # Replace with function body.
