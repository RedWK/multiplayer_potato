extends KinematicBody2D

const MOTION_SPEED = 100.0
onready var se = $SE


export var player_color = Color.white

# DASH
var dash_speed = 350
var dashing = false
var dash_time = 0.8
var dash_max = 3
var dash_count = dash_max
var dir = Vector2.RIGHT
# SHOOT
var shooting = false
var shoot_timer_reset = 0.15
var shoot_timer = shoot_timer_reset




var current_anim = ""



func get_direction_from_input():
	var move_dir = Vector2.ZERO
	# 左右
	move_dir.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	# 上下
	move_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#move_dir = move_dir.clamped(1)
	move_dir = move_dir.normalized()
	return move_dir# * dash_speed#move_dir.normalized() * dash_speed#


func _input(event):
	if event.is_action_pressed("dash") \
		and !dashing and dash_count > 0 and dash_count != 0\
		and get_direction_from_input() != Vector2.ZERO:
		$push_range.monitorable = true
		$Push/collision.disabled = false
		$push_rest.start(.35)
		$dash_count.remove_count(1)
		dash_count -= 1
		dashing = true
		dash_time = 0.2
		pass

func shoot():
	if gamestate.potato_ammo > 0:
		gamestate.potato_ammo -= 1
		se.play()
		var bullet = load("res://scene/add/bullet.tscn").instance()
		var input_dir = get_direction_from_input()
		var shoot_dir = dir
		if input_dir != Vector2.ZERO:
			shoot_dir = input_dir
		get_parent().add_child(bullet)
		bullet.ready_pos(position,  shoot_dir)
		shoot_timer = shoot_timer_reset
	else:
		pass


func add_dash(n):
	if dash_count < dash_max : dash_count += n
	if dash_count > dash_max : dash_count = dash_max
	$dash_count.add_count(n, dash_max, player_color)
	pass

#var arrow_dir = Vector2.ZERO

func _physics_process(_delta):
	var motion = Vector2()
	
	if shoot_timer > 0 : shoot_timer -= _delta
	if dash_time > 0 : dash_time -= _delta
	if dash_time <= 0 : dashing = false
	
	#var input_dir = Vector2.ZERO
	#input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#input_dir = input_dir.normalized()
	
	if !dashing:
		if Input.is_action_pressed("move_left"):
			$sprite.flip_h = true
			$outline.flip_h = true
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			$sprite.flip_h = false
			$outline.flip_h = false
			motion += Vector2(1, 0)
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			motion += Vector2(0, 1)

	if Input.is_action_pressed("shoot") and shoot_timer <= 0:
		shoot()


	var new_anim = "standing"
	if motion.y < 0:
		dir = Vector2.UP
		#arrow_dir = Vector2(-1, -1)
		new_anim = "walk_up"
	elif motion.y > 0:
		dir = Vector2.DOWN
		new_anim = "walk_down"
	elif motion.x < 0:
		dir = Vector2.LEFT
		new_anim = "walk_left"
	elif motion.x > 0:
		dir = Vector2.RIGHT
		new_anim = "walk_right"
	var input_dir = get_direction_from_input()
	if input_dir == Vector2.ZERO:
		input_dir = dir
	var dir_angle = -input_dir.normalized().angle()

	$arrow.rotation = -dir_angle
	#print(dir_angle,"rotation=",$arrow.rotation)

	if new_anim != current_anim:
		current_anim = new_anim
		get_node("anim").play(current_anim)

	if dashing:
		var dash = get_direction_from_input()
		move_and_slide(dash * dash_speed)
	else:
		move_and_slide(motion * MOTION_SPEED)



func _ready():
	$dash_count.get_stylebox("panel", "").border_color = player_color
	$outline.get_material().set_shader_param("outline_color", player_color)
	$dash_count.set_count(3)
	$label.add_color_override("font_color", player_color)
	$arrow.self_modulate = player_color
	for c in $dash_count/counts.get_children():
		c.self_modulate = player_color


func _on_push_rest_timeout():
	$Push/collision.disabled = true
	$push_range.monitorable = false
