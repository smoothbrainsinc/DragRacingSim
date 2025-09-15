
extends Node3D

func _input(event):
	# Press SPACEBAR to start the race countdown
	if event.is_action_pressed("ui_accept"): 
		if GameManager.current_state == GameManager.RaceState.WAITING:
			GameManager.trigger_race_start()
			print("Race start triggered from main.gd")
