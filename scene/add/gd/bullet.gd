extends Area2D
var dir = Vector2.ZERO
var mspeed = 200.5
var can_kill = true

func _ready():
	add_to_group("bullet")

func ready_pos(pos, input):
	dir = input	
	position = pos

func _physics_process(_delta):
	if !can_kill : $Push/CollisionShape2D.disabled = false
	position = position + dir * _delta * mspeed
	pass 

func _on_killself_timeout():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	#print("del")
	pass # Replace with function body.
