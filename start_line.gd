extends Area3D

func _ready():
	# Ensure collision shape is set up
	if not $CollisionShape3D:
		print("Warning: Add a CollisionShape3D to StartLine in main.tscn")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if body is VehicleBody3D and (body.name == "Dragster_Vehicle" or body.name == "OpponentVehicle"):
		print(body.name, " entered start line")
		# Check if both cars are ready (simplified for now)
		if get_overlapping_bodies().size() >= 2:  # Assume 2 cars
			GameManager.trigger_race_start()
			print("Both cars at start line - race starting!")
