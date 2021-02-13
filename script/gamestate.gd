extends Node

var Globalplayer = null
var Globalpringles = null

var score = 0

var potato_ammo = 0

var item_index = 0
var p_index = 0
var potato_index = 0


# Signals to let lobby GUI know what's going on.
signal game_ended()



func _ready():
	Engine.time_scale = 1
	pass

func begin_game():
	var world = load("res://scene/world.tscn").instance()
	get_tree().get_root().add_child(world)

	get_tree().get_root().get_node("Lobby").hide()

	var player_scene = load("res://scene/player.tscn")

	var spawn_pos = world.get_node("SpawnPoints/0").position
	var player = player_scene.instance()
	player.add_to_group("player")
	world.get_node("Players").add_child(player)
	player.position = spawn_pos
	Globalplayer = player
	score = 0
	potato_ammo = 25

#func delete_children(node):
#	for n in node.get_children():
#		node.remove_child(n)
#		n.queue_free()
#	node.queue_free()

func end_game():
	get_tree().quit()
	#if has_node("/root/World"): # Game is in progress.
		# End it
	#	get_node("/root/World").queue_free()
	#	get_node("/root/Lobby").queue_free()
	#var lobby = load("res://scene/lobby.tscn").instance()
	#get_tree().get_root().add_child(lobby)
	#emit_signal("game_ended")
	#var del_potato = get_tree().get_root().get_node("World")
	#delete_children(del_potato)
	#players.clear()
	
	#peer = null
	#p_index = 0
	#potato_index = 0

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r

func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var q2 = p2.linear_interpolate(p3, t)
	var r0 = q0.linear_interpolate(q1, t)
	var r1 = q1.linear_interpolate(q2, t)
	var s = r0.linear_interpolate(r1, t)
	return s
