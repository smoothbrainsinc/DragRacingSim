extends VehicleBody3D

@export var max_engine_force = 200.0
@export var max_brake_force = 100.0
@export var max_steering = 0.5

var can_move = false

func _ready():
	# Connect to GameManager signal directly
	if GameManager and GameManager.has_signal("race_started"):
		GameManager.race_started.connect(_on_race_started)
	else:
		print("Warning: GameManager or race_started signal not found")

	# Connect to finish line
	var finish = get_node_or_null("/root/main/FinishLine")
	if finish:
		finish.player_finished.connect(_on_player_finished)

	print("GameManager available: ", GameManager)

func _on_race_started():
	can_move = true
	print("Player can move!")

func _on_player_finished():
	can_move = false
	print("Player finished!")
	engine_force = 0
	brake = max_brake_force  # Apply brakes to stop

func _physics_process(_delta):
	if not can_move:
		if linear_velocity.length() < 0.1:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
		return

	# Handle acceleration and braking
	if Input.is_action_pressed("accelerate"):
		engine_force = max_engine_force
	elif Input.is_action_pressed("brake"):
		brake = max_brake_force
	else:
		engine_force = 0
		brake = 0

	# Handle steering
	steering = 0
	if Input.is_action_pressed("ui_left"):
		steering = max_steering
	elif Input.is_action_pressed("ui_right"):
		steering = -max_steering

	# Stabilization
	if linear_velocity.length() < 0.1:
		apply_central_force(-ProjectSettings.get_setting("physics/3d/default_gravity") * mass * 0.05)
