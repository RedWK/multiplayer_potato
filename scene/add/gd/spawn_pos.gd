extends Position2D

#var potato_index = 0
var pre_potato = ""

func _ready():
	pre_potato = ""
	gamestate.p_index = 0

sync func setup_potato(potato_name, pos):
	if potato_name != pre_potato:
		var potato = preload("res://scene/add/potato_spawn.tscn").instance()
		potato.set_name(potato_name) # Ensure unique name for the potato
		potato.position = pos
		get_parent().get_node("Rocks").add_child(potato)
		pre_potato = potato_name
		gamestate.p_index += 1

func _on_Timer_timeout():
	var limit_up = get_parent().get_node("limit_up")
	var limit_down = get_parent().get_node("limit_down")
	var x = rand_range(limit_up.position.x, limit_down.position.x)
	var y = rand_range(limit_up.position.y, limit_down.position.y)
	position = Vector2(x, y)

	var potato_name = "p" + str(gamestate.p_index)
	var potato_pos = position
	rpc("setup_potato", potato_name, potato_pos)#, get_tree().get_network_unique_id())
		
	
