extends Node

export (PackedScene) var _intro_scene
export (PackedScene) var _next_scene
export (PackedScene) var _debug_scene
export (PackedScene) var _pause_menu


func _ready() -> void:
	var level_to_go : PackedScene
	if OS.is_debug_build():
		level_to_go = _debug_scene
	else:
		level_to_go = _next_scene
	
	if OS.get_screen_size().x < 1280:
		OS.window_size.x = OS.get_screen_size().x
	if OS.get_screen_size().y < 720:
		OS.window_size.y = OS.get_screen_size().y
	
	config.load_config()
#	_go_to_next_scene()
	interactive_loader.go_to_level(level_to_go.get_path(), level_to_go.instance().get_node("player_spawn").position)


func _go_to_next_scene() -> void:
	interactive_loader.go_to_scene(_next_scene.get_path())
	if _next_scene != null:
		get_tree().change_scene_to(_next_scene)
