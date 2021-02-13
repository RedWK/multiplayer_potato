extends Panel

onready var counts = $counts
onready var count = preload("res://scene/add/count.tscn")
#onready var timer = $Timer



func _physics_process(delta):
	fix_count()
	pass


func fix_count():
	var now_counts = counts.get_child_count()
	if now_counts != gamestate.Globalplayer.dash_count:
		set_count(gamestate.Globalplayer.dash_count)
		pass
	pass





func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func set_count(dash, dashmax=3):
	delete_children(counts)
	rect_size.x = dashmax * 3 + 3
	rect_size.y = 6
	rect_position.x = -( dashmax * 3 + 3) / 2
	rect_position.y = 10
	for i in dash:
		var c = count.instance()
		counts.add_child(c)
		if gamestate.Globalplayer != null:
			c.self_modulate = gamestate.Globalplayer.player_color

func remove_count(num):
	var now_counts = counts.get_children()
	var new_count = now_counts.size() - num
	for i in range(now_counts.size() - 1, new_count -1 , -1):
		if i >= 0:
			now_counts[i].queue_free()

func add_count(add ,dashmax, color):
	var now_counts = counts.get_child_count()
	#if (now_counts + add) > dashmax:
	#	add = 0
	if now_counts < dashmax:
		for i in add:
			var c = count.instance()
			counts.add_child(c)
			c.self_modulate = color
	#gamestate.Globalplayer.can_pick_chip = true
