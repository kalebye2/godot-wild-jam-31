extends Node

export (PackedScene) var _intro_scene
export (PackedScene) var _next_scene
export (PackedScene) var _pause_menu


func _ready() -> void:
	_go_to_next_scene()


func _go_to_next_scene() -> void:
	if _next_scene != null:
		get_tree().change_scene_to(_next_scene)
