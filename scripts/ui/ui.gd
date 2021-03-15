extends Control


func _ready() -> void:
	rect_pivot_offset = rect_size / 2
	# check if is web version
	if OS.has_feature("JavaScript"):
		$panel/list/exit.hide()
	
	if $options.visible:
		$options.hide()
	
#	$panel/list/continue.grab_focus()


func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()



func _on_options_pressed() -> void:
	$options.show()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_visibility_changed() -> void:
	$panel/list/options.grab_focus()


func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		if $options.visible:
			$options.hide()
		else:
			hide()
	
	if event.is_action_pressed("pause"):
		visible = !visible


func _on_ui_visibility_changed():
	if visible:
		$options.hide()
		$tween.interpolate_property(self, "rect_scale", Vector2.ZERO, Vector2.ONE, .3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$tween.start()
		get_tree().paused = true
		$panel/list/continue.grab_focus()
	else:
		get_tree().paused = false
