extends KinematicBody2D


var enemy_id = 1

var maxhp = 3
var hp = maxhp
var vel = Vector2.ZERO
var knockback = 400
var move_speed = 39.5
var hit = false

var can_fus = true
var fusion = false
var fus = preload("res://scene/add/enemy2.tscn")
var fus_other = null

func _ready():
	add_to_group("enemy")

func _physics_process(_delta):
	if hit:
		vel = lerp(vel, Vector2.ZERO, 0.3)
	elif !can_fus:
		vel = Vector2.ZERO
	else:
		vel = position.direction_to(gamestate.Globalplayer.position) * move_speed
	if !hit:
		if vel.x < 0 and $outline.flip_h == true:
			$outline.flip_h = false
			$outline/Sprite.flip_h = false
		elif vel.x > 0 and !$outline.flip_h:
			$outline.flip_h = true
			$outline/Sprite.flip_h = true
	move_and_slide(vel)


func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		if area.can_kill:
			hp -= 1
		vel = area.dir * knockback
		hit = true
		$AnimationPlayer.play("hit")
		$re.start(.6)
		# delete bullet
		area.queue_free()
	if area.name == "push_range":
		hp -= 2
		var dir = (position - gamestate.Globalplayer.position).normalized()
		vel = dir * knockback
		hit = true
		$AnimationPlayer.play("hit")
		$re.start(.6)
		#print("push")
	#-------
	# dead
	#-------
	if hp <= 0 :
		$"../..".add_score(1)
		queue_free()
	#print("hit")


# 合併
func fusion(other):
	if !can_fus:
		var bigger = fus.instance()
		get_parent().call_deferred("add_child", bigger)
		var pos = (position + other.position) / 2
		bigger.position = pos
		other.queue_free()
		queue_free()
	else:
		other.can_fus = true

# 合併條件
func _on_fus_range_body_entered(body):
	if body.is_in_group("enemy") and can_fus \
		and enemy_id == body.enemy_id and !hit and !body.hit\
		and body != self and body.can_fus == true:
		body.can_fus = false
		can_fus = false
		fusion(body)
		body.reset()
		reset()


func _on_re_timeout():
	hit = false
	can_fus = true


func reset():
	$re.start(.6)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
