extends Area2D
var dir = Vector2.ZERO
var mspeed = 200.5


func _ready():
	add_to_group("bullet")
# Called when the node enters the scene tree for the first time.
func ready_pos(pos, input):
	dir = input	
	position = pos

func _physics_process(_delta):
	position = position + dir * _delta * mspeed
	pass 

func _on_killself_timeout():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	#print("del")
	pass # Replace with function body.
