extends Node

var path = "user://config.ini"

# window variables
var res_width : int = ProjectSettings.get_setting("display/window/size/width")
var res_height : int = ProjectSettings.get_setting("display/window/size/height")
var res_multiplier : float = 1.0


func load_config():
	var file = ConfigFile.new()
	file.load(path)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), file.get_value("Sound", "SFX", 0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), file.get_value("Sound", "Music", -7))
	OS.window_fullscreen = file.get_value("Window", "FullScreen", false)
	var resolution = Vector2(file.get_value("Window", "Width", 1280), file.get_value("Window", "Height", 720))
	res_width = resolution.x
	res_height = resolution.y
	res_multiplier = resolution.x / ProjectSettings.get_setting("display/window/size/width")
#	res_multiplier = ProjectSettings.get_setting("display/window/size/width") / resolution.x
#	print(res_multiplier)
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, resolution, res_multiplier)
	get_tree().get_root().size = resolution
	if !OS.window_fullscreen:
		OS.window_size = resolution
	

func save_config():
#	print("%d x %d" % [res_width, res_height])
	var file = ConfigFile.new()
	file.set_value("Sound", "SFX", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))
	file.set_value("Sound", "Music", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music")))
	file.set_value("Window", "FullScreen", OS.window_fullscreen)
	file.set_value("Window", "Width", res_width)
	file.set_value("Window", "Height", res_height)
	var err = file.save(path)
	if err != OK:
		print("Error saving file!")
