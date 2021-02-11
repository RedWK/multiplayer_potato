extends Path2D

var enemy = preload("res://scene/add/enemy.tscn") 

func _on_spawn_enemy_timeout():
	$spawn_pos.offset = randi()
	var e = enemy.instance()
	get_parent().get_node("Enemy").add_child(e)
	e.position = $spawn_pos.global_position
	
