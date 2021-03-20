extends Node2D

export (String) var level_to_go
export (Vector2) var spawn_position


signal exiting_area


func _on_exit_level_exiting_area():
	global_data.playing = false
	player_data.reset_data()
	var next_node : PackedScene
	
	# debug purposes
#	if OS.is_debug_build():
#		next_node = global_data.game_debug_start
#	else:
#		next_node = global_data.game_start
	
	next_node = global_data.game_start
	
	player_data.spawn_location = next_node.instance().get_node("player_spawn").position
	
	get_tree().paused = false
	queue_free()
	
	interactive_loader.go_to_level(next_node.get_path(), next_node.instance().get_node("player_spawn").position)
