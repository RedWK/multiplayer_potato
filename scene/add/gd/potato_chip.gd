extends Area2D

var can_pick = false
var move = false
var pick = false
var to = null
var by_who = null


var throw_pos = Vector2.ZERO

func _ready():
	$Sprite.self_modulate = Color(1, 1, 1, 0.5)
	$AnimationPlayer.play("shine")
	throw_pos = $"../../spawn_item".position
	#print(throw_pos)


var t = 1
func _physics_process(_delta):
	if t >= 1: t-=0.1
	if t <= 0 : t+=0.1
	if move and position != to.position:
		position += ((to.position - position) * t) / 10
	if position != throw_pos:
		position += ((throw_pos - position) * t)  / 10
	


func _on_potato_chip_body_entered(body):
	if body.is_in_group("player") and can_pick:
		pick = true
		move = false
		#$"../../Score".rpc("increase_score", int(body.name))
		#print("pick=",by_who)
		body.add_dash(1)
		queue_free()

func _on_potato_chip_area_entered(area):
	if area.name == "collect_range" \
		and area.get_parent().is_in_group("player")\
		and !pick and can_pick:
		to = area.get_parent()
		#by_who = int(to.name)
		move = true

func _on_potato_chip_area_exited(area):
	if area.name == "collect_range" \
		and area.get_parent().is_in_group("player")\
		and !pick and can_pick:
		to = null
		move = false

func _on_can_pick_timeout():
	$Sprite.self_modulate = Color(1, 1, 1, 1)
	can_pick = true


func _on_killself_timeout():
	queue_free()


