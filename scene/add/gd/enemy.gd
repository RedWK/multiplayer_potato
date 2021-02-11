extends KinematicBody2D

var maxhp = 3
var hp = maxhp
var vel = Vector2.ZERO
var knockback = 400
var move_speed = 39.5
var hit = false

func _ready():
	add_to_group("enemy")
	pass # Replace with function body.

func _physics_process(_delta):
	if hit:
		vel = lerp(vel, Vector2.ZERO, 0.3)
	else:
		vel = position.direction_to(gamestate.Globalplayer.position) * move_speed
	if !hit:
		if vel.x < 0 and $Sprite.flip_h == true:
			$Sprite.flip_h = false
		elif vel.x > 0 and !$Sprite.flip_h:
			$Sprite.flip_h = true
	move_and_slide(vel)
	pass


func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		hp -= 1
		vel = area.dir * knockback
		hit = true
		$AnimationPlayer.play("hit")
		$re.start(.6)
		# delete bullet
		area.queue_free()
		#-------
		# dead
		#-------
		if hp <= 0 :
			$"../..".add_score(1)
			queue_free()
		#print("hit")


func _on_re_timeout():
	hit = false
