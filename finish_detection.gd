extends Area3D

signal player_finished
signal opponent_finished

func _on_body_entered(body):
	if body.name == "PlayerCar":
		print("Player finished!")
		player_finished.emit()
	elif body.name == "OpponentVehicle":
		print("Opponent finished!")
		opponent_finished.emit()
	# Future: Add timing (elapsed time from race start)
	body.linear_velocity = Vector3.ZERO  # Basic stop
