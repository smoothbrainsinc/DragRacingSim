extends Node

@export var start_camera: Camera3D
@export var player_camera: Camera3D  
@export var finish_camera_player: Camera3D
@export var finish_camera_opponent: Camera3D

func _ready():
	if start_camera:
		start_camera.make_current()

func switch_to_player():
	if player_camera:
		player_camera.make_current()

func switch_to_finish_player():
	if finish_camera_player:
		finish_camera_player.make_current()
		
func switch_to_finish_opponent():
	if finish_camera_opponent:
		finish_camera_opponent.make_current()
