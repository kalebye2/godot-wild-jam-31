extends Node2D

export (String) var level_to_go
export (Vector2) var spawn_position


signal exiting_area


func _on_exit_level_exiting_area():
	if level_to_go == "":
		return
	player_data.spawn_location = spawn_position
	interactive_loader.go_to_level(level_to_go, spawn_position)
