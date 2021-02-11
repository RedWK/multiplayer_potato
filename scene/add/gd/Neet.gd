extends KinematicBody2D

var potato_chip = preload("res://scene/add/potato_chip.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pre_item = ""

var throw_item_bar_max = 10
var throw_item_bar = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Node2D/throw.max_value = throw_item_bar_max
	pass

func _physics_process(_delta):
	
	pass

func setup_item(item_name, pos):
	if item_name != pre_item:
		var item = potato_chip.instance()
		item.set_name(item_name) # Ensure unique name for the item
		item.position = pos
		get_parent().get_node("Rocks").add_child(item)
		pre_item = item_name
		gamestate.item_index += 1

func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		if throw_item_bar < throw_item_bar_max:
			throw_item_bar += 1
			$Node2D/throw.value = throw_item_bar
		area.queue_free()
		print("hit")
	pass # Replace with function body.


func _on_throw_chip_timeout():
	var item_name = "p" + str(gamestate.item_index)
	var item_pos = position
	setup_item(item_name, item_pos)
	pass # Replace with function body.


func _on_throw_value_changed(value):
	if value == $Node2D/throw.max_value:
		$Node2D/throw.value = 0
		throw_item_bar = 0
		_on_throw_chip_timeout()
	pass # Replace with function body.
