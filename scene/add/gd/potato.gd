extends Area2D

var can_pick = false
var move = false
var pick = false
var to = null
var by_who = null

func _physics_process(_delta):
	if move and position != to.position:
		position += (to.position - position) / 10


func _on_potato_body_entered(body):
	if body.is_in_group("player") and can_pick:
		pick = true
		move = false

		queue_free()

func _on_potato_area_entered(area):
	if area.name == "collect_range" and !pick and can_pick:
		to = area.get_parent()

		move = true

func _on_potato_area_exited(area):
	if area.name == "collect_range" and !pick and can_pick:
		to = null
		move = false

func _on_can_pick_timeout():
	$Sprite.self_modulate = Color(1, 1, 1, 0.65)
	can_pick = true


func _on_killself_timeout():
	queue_free()
