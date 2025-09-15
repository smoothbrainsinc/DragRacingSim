
extends VehicleBody3D

@export var max_engine_force = 180.0
var can_move = false

func _ready():
	var ui = get_node("/RaceUI")
	if ui:
		ui.race_started.connect(_on_race_started)
	
	var finish = get_node("../Track/FinishLine/DetectionArea")
	if finish:
		finish.opponent_finished.connect(_on_opponent_finished)

func _on_race_started():
	print("Opponent can move!")
	can_move = true

func _physics_process(_delta):
	if can_move:
		engine_force = max_engine_force  # Simple AI - just go forward
		# Future: Add steering AI, variability, failures

func _on_opponent_finished():
	print("Opponent finished!")
	engine_force = 0
	brake = 100.0
