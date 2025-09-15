
extends VehicleBody3D

@export var max_engine_force = 200.0
@export var max_brake_force = 100.0
@export var max_steering = 0.5

var can_move = false

func _ready():
	# Connect to UI signals
	var ui = get_node("../RaceUI")  # Adjust path as needed
	if ui:
		ui.race_started.connect(_on_race_started)
	
	# Connect to finish line
	var finish = get_node("../Track/FinishLine/DetectionArea")  # Adjust path as needed
	if finish:
		finish.player_finished.connect(_on_player_finished)

	print("GameManager available: ", GameManager)

func _on_race_started():
	print("Player can move!")
	can_move = true

func _physics_process(_delta):
	if not can_move:
		return
		
	# Engine/Brake
	engine_force = 0
	brake = 0
	
	if Input.is_action_pressed("ui_up"):  # Or whatever your accelerate key is
		engine_force = max_engine_force
	elif Input.is_action_pressed("ui_down"):  # Brake/reverse
		brake = max_brake_force
	
	# Steering
	steering = 0
	if Input.is_action_pressed("ui_left"):
		steering = max_steering
	elif Input.is_action_pressed("ui_right"):
		steering = -max_steering

func _on_player_finished():
	print("Player finished!")
	engine_force = 0
	brake = max_brake_force
