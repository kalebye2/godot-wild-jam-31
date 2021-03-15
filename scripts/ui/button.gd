extends Button

export (Vector2) var max_scale = Vector2(1, 1)

func _ready():
	rect_pivot_offset = rect_size / 2

func _on_Button_focus_entered():
	if !visible:
		return
	$focus.play()
	$tween.interpolate_property(self, "rect_scale", Vector2.ONE, max_scale, .2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$tween.start()


func _on_Button_focus_exited():
	$tween.interpolate_property(self, "rect_scale", max_scale, Vector2.ONE, .4, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$tween.start()


func _on_Button_mouse_entered():
	grab_focus()


func _on_button_pressed():
	if !visible:
		return
	$click.play()
