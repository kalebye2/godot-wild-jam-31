extends Panel


func _ready():
	rect_pivot_offset = rect_size / 2
	
	$v_box_container/items/sfx_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx"))
	$v_box_container/items/music_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music"))


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


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), value)
