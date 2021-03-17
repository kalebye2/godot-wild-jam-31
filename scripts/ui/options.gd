extends Panel

var base_res_width : int = ProjectSettings.get_setting("display/window/size/width")
var base_res_height : int = ProjectSettings.get_setting("display/window/size/height")
var res_multiplier : float = 1.0
var res_multiplier_options : Array = [1.0, .5, .25]
var res_multiplier_index = 0

func _ready():
	
	$v_box_container/items2/button.pressed = OS.window_fullscreen
	
	rect_pivot_offset = rect_size / 2
	
	$v_box_container/items/sfx_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx"))
	$v_box_container/items/music_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music"))
	
	$v_box_container/items2/btn_res.text = "%d x %d" % [config.res_width, config.res_height]


func _on_voltar_pressed() -> void:
	hide()


func _on_options_visibility_changed() -> void:
	if visible:
		$tween.interpolate_property(self, "rect_scale", Vector2.ZERO, Vector2.ONE, .3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$tween.start()
		$v_box_container/items/sfx_slider.grab_focus()
		$v_box_container/items/sfx_slider.now_you_can = true
		$v_box_container/items/music_slider.now_you_can = true


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), value)
	config.save_config()


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), value)
	config.save_config()


func _on_button_toggled(button_pressed):
	$v_box_container/items2/button.text = "on" if button_pressed else "off"
	
	OS.window_fullscreen = button_pressed
	config.save_config()
	config.load_config()
	


func _on_btn_res_pressed():
	res_multiplier_index = res_multiplier_options.find(config.res_multiplier)
	
	if res_multiplier_index < res_multiplier_options.size() - 1:
		res_multiplier_index += 1
	else:
		res_multiplier_index = 0
#	print(res_multiplier_options[res_multiplier_index])
	config.res_height = base_res_height * res_multiplier_options[res_multiplier_index]
	config.res_width = base_res_width * res_multiplier_options[res_multiplier_index]
	$v_box_container/items2/btn_res.text = "%d x %d" % [config.res_width, config.res_height]
#	config.res_multiplier = res_multiplier_options[res_multiplier_index]
	config.save_config()
	config.load_config()
