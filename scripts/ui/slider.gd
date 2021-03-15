extends HSlider

export (Vector2) var first_scale = Vector2(.9, .9)

var now_you_can : bool = false

func ready():
	rect_pivot_offset = rect_size / 2

func _on_sfx_slider_focus_entered():
	$tween.interpolate_property(self, "rect_scale", first_scale, Vector2.ONE, .3, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$tween.start()
	$sound.play()


func _on_slider_value_changed(value):
	pass
