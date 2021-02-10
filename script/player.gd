extends KinematicBody2D

const MOTION_SPEED = 100.0

export var player_color = Color.white

var dash_speed = 350
var dashing = false
var dash_time = 0.8
var dash_max = 3
var dash_count = dash_max

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

export var stunned = false

# Use sync because it will be called everywhere
#sync func setup_bomb(bomb_name, pos, by_who):
#	var bomb = preload("res://scene/bomb.tscn").instance()
#	bomb.set_name(bomb_name) # Ensure unique name for the bomb
#	bomb.position = pos
#	bomb.from_player = by_who
#	# No need to set network master to bomb, will be owned by server by default
#	get_node("../..").add_child(bomb)

var current_anim = ""
var prev_bombing = false
var bomb_index = 0

func get_direction_from_input():
	var move_dir = Vector2()
	# 左右
	move_dir.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	# 上下
	move_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	move_dir = move_dir.clamped(1)
	return move_dir * dash_speed#move_dir.normalized() * dash_speed#


func _input(event):
	if is_network_master():
		if event.is_action_pressed("ui_accept") \
			and !dashing and dash_count > 0 and dash_count != 0\
			and get_direction_from_input() != Vector2.ZERO:
			var c = get_tree().get_root().get_node("World/Score").player_labels[int(name)]
			print(c)
			$dash_count.remove_count(1)
			dash_count -= 1
			dashing = true
			dash_time = 0.2



func add_dash(n):
	dash_count += n
	#$dash_count.set_count(get_tree().get_root().get_node("World/Score").player_labels[int(name)].dash)
	#print(get_tree().get_root().get_node("World/Score").player_labels[int(name)].dash)
	#
	$dash_count.add_count(n, dash_max)
	pass


func _physics_process(_delta):
	var motion = Vector2()
	
	if dash_time > 0 : dash_time -= _delta
	if dash_time <= 0 : dashing = false
	
	if is_network_master():
		if !dashing:
			if Input.is_action_pressed("move_left"):
				motion += Vector2(-1, 0)
			if Input.is_action_pressed("move_right"):
				motion += Vector2(1, 0)
			if Input.is_action_pressed("move_up"):
				motion += Vector2(0, -1)
			if Input.is_action_pressed("move_down"):
				motion += Vector2(0, 1)

		#var bombing = Input.is_action_pressed("set_bomb")

		#if stunned:
		#	bombing = false
		#	motion = Vector2()

		#if bombing and not prev_bombing:
		#	var bomb_name = get_name() + str(bomb_index)
		#	var bomb_pos = position
		#	rpc("setup_bomb", bomb_name, bomb_pos, get_tree().get_network_unique_id())

		#prev_bombing = bombing

		rset("puppet_motion", motion)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		motion = puppet_motion

	var new_anim = "standing"
	if motion.y < 0:
		new_anim = "walk_up"
	elif motion.y > 0:
		new_anim = "walk_down"
	elif motion.x < 0:
		new_anim = "walk_left"
	elif motion.x > 0:
		new_anim = "walk_right"

	if stunned:
		new_anim = "stunned"

	if new_anim != current_anim:
		current_anim = new_anim
		get_node("anim").play(current_anim)

	# FIXME: Use move_and_slide
	if dashing and is_network_master():
		var dash = get_direction_from_input()
		move_and_slide(dash)
		#print(dash * MOTION_SPEED)
	else:
		move_and_slide(motion * MOTION_SPEED)
		#print(motion * MOTION_SPEED)
	#move_and_slide(motion * MOTION_SPEED, Vector2.UP, false, 4, PI/4, false)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

puppet func stun():
	stunned = true

master func exploded(_by_who):
	if stunned:
		return
	rpc("stun") # Stun puppets
	stun() # Stun master - could use sync to do both at once

func set_player_name(new_name):
	get_node("label").set_text(new_name)

func _ready():
	$dash_count.get_stylebox("panel", "").border_color = player_color
	$outline.get_material().set_shader_param("outline_color", player_color)
	$dash_count.set_count(3)
	$label.add_color_override("font_color", player_color)
	for c in $dash_count/counts.get_children():
		c.self_modulate = player_color
		pass
	
	stunned = false
	puppet_pos = position
