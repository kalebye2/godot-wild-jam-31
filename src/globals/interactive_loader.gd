extends Node


var loader : ResourceInteractiveLoader
var is_level : bool = false
var current_scene : Node

func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func _process(delta) -> void:
	if loader == null:
		set_process(false)
		return
	
	
	var err = loader.poll()
	if err == ERR_FILE_EOF:
		var resource = loader.get_resource()
		if is_level:
			if !player_data.spawn_init:
				player_data.spawn_location = resource.instance().get_node("player_spawn").position
				player_data.spawn_init = true
#		print(player_data.spawn_location)
		get_tree().change_scene_to(resource)
		loader = null
	elif err == OK:
		pass
	else:
		print("Error")
		loader = null


func go_to_scene(path : String) -> void:
	is_level = false
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		print("error")
		return
	set_process(true)
	
	current_scene.queue_free()
	

func go_to_level(path : String, player_position : Vector2) -> void:
	is_level = true
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		print("error")
		return
	set_process(true)
