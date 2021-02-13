extends Area2D

var can_pick = false
var move = false
var pick = false
var to = null
var by_who = null

#var p3 = Vector2.ZERO
var t = 0.0
func _physics_process(_delta):
	if t >= 1: t-=0.1
	if t <= 0 : t+=0.1
	#t += _delta / 2.5
	if to != null:
		if move and position != to.position:
			#if p3 == Vector2.ZERO : p3 = position+Vector2(16,16)
			#var q0 = position.linear_interpolate(p3, min(t, 1.0))
			#var q1 = p3.linear_interpolate(to.position, min(t, 1.0))
			#position = q0.linear_interpolate(q1, min(t, 1.0))
			position += ((to.position - position) * t)


func _on_potato_body_entered(body):
	#if (body.is_in_group("player") or body.is_in_group("enemy")) and can_pick:
	if can_pick:
		pick = true
		move = false
		if body.is_in_group("player"):
			if gamestate.potato_ammo >= 100:
				to = gamestate.Globalpringles
				move = true
			else:
				gamestate.potato_ammo += 2.5
				if gamestate.potato_ammo > 100:
					gamestate.potato_ammo = 100
				queue_free()
			#print("player")
		elif body.is_in_group("Pringles"):
			body.add_throw_bar(1)
			queue_free()
		elif body.is_in_group("enemy"):
			queue_free()


func _on_potato_area_entered(area):
	if area.name == "collect_range" and !pick and can_pick:
		to = area.get_parent()
		move = true

func _on_potato_area_exited(area):
	if area.name == "collect_range" and !pick and can_pick:
		to = null
		move = false
		pass

func _on_can_pick_timeout():
	$Sprite.self_modulate = Color(1, 1, 1, 0.65)
	can_pick = true


func _on_killself_timeout():
	queue_free()
