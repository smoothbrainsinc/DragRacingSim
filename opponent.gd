extends VehicleBody3D

@export var max_engine_force = 180.0
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
		finish.opponent_finished.connect(_on_opponent_finished)

func _on_race_started():
	can_move = true
	print("OPPONENT: Race started signal received. can_move = ", can_move)

func _physics_process(_delta):

	if can_move:
		engine_force = max_engine_force  # Simple AI - just go forward
		print("OPPONENT: Applying force: ", engine_force)  # Debug print
	else:
		engine_force = 0
		brake = 100.0  # Brake when not allowed to move
	
func _on_opponent_finished():
	print("Opponent finished!")
	
