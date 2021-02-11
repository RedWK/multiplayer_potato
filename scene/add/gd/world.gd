extends Node2D

var score = 0


func add_score(n):
	score += n
	$Node2D/score.text = "Score  :  " + str(score)

func _on_ExitGame_pressed():
	gamestate.end_game()
