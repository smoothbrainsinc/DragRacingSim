# RaceUI.gd
extends CanvasLayer
class_name RaceUI

@onready var countdown_label: Label = $CountdownLabel
@onready var race_time_label: Label = $RaceTimeLabel
@onready var results_panel: Panel = $ResultsPanel
@onready var winner_label: Label = $ResultsPanel/WinnerLabel
@onready var restart_button: Button = $ResultsPanel/RestartButton

func _ready() -> void:
	# Connect to GameManager signals
	GameManager.ui_update_countdown.connect(_on_countdown_update)
	GameManager.race_started.connect(_on_race_started)
	GameManager.race_finished.connect(_on_race_finished)
	GameManager.state_changed.connect(_on_state_changed)
	
	# Connect restart button
	restart_button.pressed.connect(_on_restart_pressed)
	
	# Initial setup
	results_panel.visible = false

func _process(_delta: float) -> void:
	# Update race timer during race
	if GameManager.current_state == GameManager.RaceState.RACING:
		var race_time = GameManager.get_race_time()
		race_time_label.text = "Time: %.2f" % race_time

func _on_countdown_update(text: String) -> void:
	countdown_label.text = text

func _on_race_started() -> void:
	countdown_label.text = ""
	race_time_label.visible = true

func _on_race_finished(winner_name: String, player_time: float, opponent_time: float) -> void:
	race_time_label.visible = false
	winner_label.text = "Winner: " + winner_name + "\nYour Time: %.2f\nOpponent Time: %.2f" % [player_time, opponent_time]
	results_panel.visible = true

func _on_state_changed(new_state: GameManager.RaceState) -> void:
	match new_state:
		GameManager.RaceState.WAITING:
			results_panel.visible = false
			race_time_label.visible = false

func _on_restart_pressed() -> void:
	GameManager.reset_race()
