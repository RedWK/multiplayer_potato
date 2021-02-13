extends KinematicBody2D

var potato_chip = preload("res://scene/add/potato_chip.tscn")

var pre_item = ""


var dir = Vector2.DOWN
var throw_item_bar_max = 5
var throw_item_bar = 0

var collect_timer = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Pringles")
	gamestate.Globalpringles = self
	$Node2D/throw.max_value = throw_item_bar_max
	pass

func _physics_process(_delta):

	pass

func setup_item(item_name, pos):
	if item_name != pre_item:
		var item = potato_chip.instance()
		item.set_name(item_name) # Ensure unique name for the item
		item.position = pos
		get_parent().get_node("Rocks").call_deferred("add_child", item)#add_child(item)
		pre_item = item_name
		gamestate.item_index += 1


func add_throw_bar(add):
	if (throw_item_bar + add) <= throw_item_bar_max:
		throw_item_bar += add
		$Node2D/throw.value = throw_item_bar


func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		add_throw_bar(1)
		area.queue_free()
		print("hit")
	pass # Replace with function body.


func _on_throw_chip_timeout():
	var item_name = "p" + str(gamestate.item_index)
	var item_pos = position
	setup_item(item_name, item_pos)
	pass # Replace with function body.


func _on_throw_value_changed(value):
	if value >= $Node2D/throw.max_value:
		var plus = value - $Node2D/throw.max_value
		if plus > 0:
			$Node2D/throw.value = plus
			throw_item_bar = plus
		else:
			$Node2D/throw.value = 0
			throw_item_bar = 0
		_on_throw_chip_timeout()
	pass # Replace with function body.


func _on_collect_timeout():
	if !$collect_range.monitoring:
		$collect_range.monitoring = true
	else:
		$collect_range.monitoring = false
