extends Area2D

#var potato_index = 0
var vel = Vector2.ZERO
onready var tween = $Tween

sync func potato_boom():
	var potato_max  = int(rand_range(2, 5))
	#print(potato_max)
	for i in potato_max:
		var potato = preload("res://scene/add/potato.tscn").instance()
		get_parent().call_deferred("add_child", potato)
		potato.set_name("potato" + str(gamestate.potato_index))
		gamestate.potato_index += 1
		var pos = position + Vector2(rand_range(-32, 32), rand_range(-32, 32))
		potato.position = position
		tween.interpolate_property(potato, "position",
				position, pos, 0.5,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		pass
	pass


func  _on_Potato_S_body_entered(body):
	if body.is_in_group("players"):
		$Sprite.set_self_modulate(Color( 0, 0, 0, 0 ))
		potato_boom()
		#print("aaa")
	pass # Replace with function body.


func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.

