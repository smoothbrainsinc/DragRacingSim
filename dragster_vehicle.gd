
extends VehicleBody3D

func _physics_process(delta):
	# Map input actions to forces
	var accelerate = Input.get_action_strength("accelerate")
	var brake = Input.get_action_strength("brake")
	var steer_input = Input.get_axis("steer_right", "steer_left") # Returns a value between -1.0 and 1.0

	# Apply the forces to the vehicle body properties
	engine_force = accelerate * 800.0  # Adjust for more/less power
	brake = brake * 40.0               # Adjust braking strength
	steering = steer_input * 0.5       # Adjust steering angle (in radians)
