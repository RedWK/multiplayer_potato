extends Position2D

var pre_item = ""

func _ready():
	pre_item  = ""
	gamestate.item_index = 0

func setup_item(item_name, pos):
	if item_name != pre_item:
		var item = preload("res://scene/add/potato_chip.tscn").instance()
		item.set_name(item_name) # Ensure unique name for the item
		item.position = pos
		get_parent().get_node("Rocks").add_child(item)
		pre_item = item_name
		gamestate.item_index += 1

func _on_Timer_timeout():
	var limit_up = get_parent().get_node("limit_up")
	var limit_down = get_parent().get_node("limit_down")
	var x = rand_range(limit_up.position.x, limit_down.position.x)
	var y = rand_range(limit_up.position.y, limit_down.position.y)
	position = Vector2(int(x), int(y))

	#var item_name = "p" + str(gamestate.item_index)
	#var item_pos = position
	#setup_item(item_name, item_pos)
	
