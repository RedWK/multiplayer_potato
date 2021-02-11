extends KinematicBody2D

var maxhp = 3
var hp = maxhp
var vel = Vector2.ZERO
var knockback = 100
var move_speed = 35.5
var hit = false

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if hit:
		vel = lerp(vel, Vector2.ZERO, 0.3)
	else:
		vel = position.direction_to(gamestate.Globalplayer.position) * move_speed
	#if vel.y < 0:
	#	dir = Vector2.UP
	#elif vel.y > 0:
	#	dir = Vector2.DOWN
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
		area.queue_free()
		if hp <= 0 :queue_free()
		print("hit")
	pass # Replace with function body.
