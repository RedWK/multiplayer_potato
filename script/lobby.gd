	extends Control

func _ready():
	# Called every time the node is added to the scene.

	gamestate.connect("game_ended", self, "_on_game_ended")

	# Set the player name according to the system username. Fallback to the path.





func _on_start_pressed():
	gamestate.begin_game()


func _on_find_public_ip_pressed():
	OS.shell_open("https://icanhazip.com/")
