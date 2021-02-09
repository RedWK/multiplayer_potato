extends Panel

onready var counts = $counts
onready var count = preload("res://scene/add/count.tscn")
onready var timer = $Timer


#var dashmax = 0

func set_count(dashmax):
	rect_size.x = dashmax * 3 + 3
	rect_size.y = 6
	rect_position.x = -( dashmax * 3 + 3) / 2
	rect_position.y = 4
	for i in dashmax:
		var c = count.instance()
		counts.add_child(c)
