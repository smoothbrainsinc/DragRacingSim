extends VehicleBody3D

@export var max_engine_force: float = 5000.0  # Per README, tunable value
@export var max_brake_force: float = 100.0
@export var max_steering: float = 0.5
@export var stabilization_factor: float = 0.01  # Export for tuning

var can_move: bool = false

func _ready() -> void:
	if GameManager and GameManager.has_signal("race_started"):
		GameManager.race_started.connect(_on_race_started)
	else:
		push_warning("GameManager or race_started signal not found")
	var finish = get_node_or_null("/root/main/FinishLine")
	if finish and finish.has_signal("player_finished"):
		finish.player_finished.connect(_on_player_finished)
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	name = "Dragster_Vehicle"  # Match StartLine detection

func _on_race_started() -> void:
	can_move = true
	print("PLAYER: Race started signal received. can_move = ", can_move)

func _physics_process(_delta: float) -> void:
	if not can_move and GameManager.can_player_input():
		push_warning("Input enabled but can_move false—check GameManager state")
		return

	if not can_move:
		engine_force = 0.0
		brake = max_brake_force
		if linear_velocity.length() < 0.1:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
		return

	if Input.is_action_pressed("accelerate"):  # SPACEBAR via InputMap
		engine_force = max_engine_force
		print("PLAYER: Applying force: %.1f Velocity: %.3f" % [engine_force, linear_velocity.length()])
	elif Input.is_action_pressed("brake"):
		brake = max_brake_force
	else:
		engine_force = 0.0
		brake = 0.0

	steering = 0.0
	if Input.is_action_pressed("ui_left"):
		steering = max_steering
	elif Input.is_action_pressed("ui_right"):
		steering = -max_steering

	print("PLAYER: Current state - Force: %.1f Velocity: %.3f" % [engine_force, linear_velocity.length()])

	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	apply_central_force(Vector3(0.0, -gravity * mass * stabilization_factor, 0.0))  # Fixed multiplier

func _on_player_finished() -> void:
	print("Player finished!")
