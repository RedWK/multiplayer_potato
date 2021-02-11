extends KinematicBody2D

var maxhp = 5
var hp = maxhp


func _ready():
	pass # Replace with function body.



func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		hp -= 1
		area.queue_free()
		if hp <= 0 :queue_free()
		print("hit")
	pass # Replace with function body.
