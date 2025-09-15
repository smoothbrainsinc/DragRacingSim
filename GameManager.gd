extends Node

# GameManager - Central game state control singleton
# Handles all race states and coordinates between systems
# NO direct scene access - everything through signals

# Race state enumeration
enum RaceState {
	WAITING,    # Cars positioning, waiting for start
	READY,      # "Ready" countdown phase  
	SET,        # "Set" countdown phase
	GO,         # "GO!" race begins
	RACING,     # Race in progress
	FINISHED    # Race completed
}

# Current race state
var current_state: RaceState = RaceState.WAITING

# Race timing
var race_start_time: float = 0.0
var race_end_time: float = 0.0
var countdown_timer: float = 0.0

# Race results
var winner: String = ""
var player_finish_time: float = 0.0
var opponent_finish_time: float = 0.0

# Countdown timing constants
const READY_DURATION: float = 1.0
const SET_DURATION: float = 1.0
const GO_DURATION: float = 0.5

# Signals for state changes - other systems connect to these
signal state_changed(new_state: RaceState)
signal countdown_ready()
signal countdown_set() 
signal race_started()
signal race_finished(winner_name: String, player_time: float, opponent_time: float)
signal ui_update_countdown(text: String)

func _ready() -> void:
	print("GameManager initialized")
	# Start in waiting state
	change_state(RaceState.WAITING)

func _process(delta: float) -> void:
	# Handle countdown timing
	match current_state:
		RaceState.READY:
			_process_ready_countdown(delta)
		RaceState.SET:
			_process_set_countdown(delta)
		RaceState.GO:
			_process_go_countdown(delta)

# Change game state and emit signals
func change_state(new_state: RaceState) -> void:
	if current_state == new_state:
		return
		
	var old_state = current_state
	current_state = new_state
	
	print("GameManager: State changed from ", RaceState.keys()[old_state], " to ", RaceState.keys()[new_state])
	
	# Emit state change signal
	state_changed.emit(new_state)
	
	# Handle state-specific setup
	match new_state:
		RaceState.WAITING:
			_setup_waiting_state()
		RaceState.READY:
			_setup_ready_state()
		RaceState.SET:
			_setup_set_state()
		RaceState.GO:
			_setup_go_state()
		RaceState.RACING:
			_setup_racing_state()
		RaceState.FINISHED:
			_setup_finished_state()

# Called externally when both cars are in position at start line
func trigger_race_start() -> void:
	if current_state == RaceState.WAITING:
		change_state(RaceState.READY)

# Called externally when a car crosses finish line
func car_finished(car_name: String, finish_time: float) -> void:
	if current_state != RaceState.RACING:
		return
		
	print("Car finished: ", car_name, " Time: ", finish_time)
	
	if car_name == "Player":
		player_finish_time = finish_time
	elif car_name == "Opponent":
		opponent_finish_time = finish_time
	
	# Check if this is the first car to finish
	if winner == "":
		winner = "Player"
		race_end_time = Time.get_time_dict_from_system()["unix"]
		change_state(RaceState.FINISHED)

# Reset race for restart
func reset_race() -> void:
	current_state = RaceState.WAITING
	winner = ""
	player_finish_time = 0.0
	opponent_finish_time = 0.0
	race_start_time = 0.0
	race_end_time = 0.0
	countdown_timer = 0.0
	change_state(RaceState.WAITING)

# State setup functions
func _setup_waiting_state() -> void:
	ui_update_countdown.emit("Position your car at the start line")

func _setup_ready_state() -> void:
	countdown_timer = READY_DURATION
	ui_update_countdown.emit("READY")
	countdown_ready.emit()

func _setup_set_state() -> void:
	countdown_timer = SET_DURATION
	ui_update_countdown.emit("SET") 
	countdown_set.emit()

func _setup_go_state() -> void:
	countdown_timer = GO_DURATION
	ui_update_countdown.emit("GO!")

func _setup_racing_state() -> void:
	race_start_time = Time.get_unix_time_from_system()
	ui_update_countdown.emit("")
	race_started.emit()
	print("Race started at: ", race_start_time)

func _setup_finished_state() -> void:
	@warning_ignore("unused_variable")
	var total_race_time = race_end_time - race_start_time
	ui_update_countdown.emit("Race Finished!\nWinner: " + winner)
	race_finished.emit(winner, player_finish_time, opponent_finish_time)

# Countdown processing functions
func _process_ready_countdown(delta: float) -> void:
	countdown_timer -= delta
	if countdown_timer <= 0.0:
		change_state(RaceState.SET)

func _process_set_countdown(delta: float) -> void:
	countdown_timer -= delta
	if countdown_timer <= 0.0:
		change_state(RaceState.GO)

func _process_go_countdown(delta: float) -> void:
	countdown_timer -= delta
	if countdown_timer <= 0.0:
		change_state(RaceState.RACING)

# Utility functions
func is_race_active() -> bool:
	return current_state == RaceState.RACING

func can_player_input() -> bool:
	return current_state == RaceState.RACING

func get_race_time() -> float:
	if current_state == RaceState.RACING:
		return Time.get_unix_time_from_system() - race_start_time
	elif current_state == RaceState.FINISHED:
		return race_end_time - race_start_time
	else:
		return 0.0
