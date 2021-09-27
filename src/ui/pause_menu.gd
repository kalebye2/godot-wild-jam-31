extends Control


func _ready() -> void:
	if player_data.collectibles == 0:
		$panel/oregano.hide()
	$death_ui/deaths.text = "%02d" % player_data.deaths
	$panel/oregano/label.text = "%d/%d" % [player_data.collectibles, player_data.TOTAL_COLLECTIBLES]
	rect_pivot_offset = rect_size / 2
	# check if is web version
	if OS.has_feature("JavaScript"):
		$panel/list/exit.hide()
	
	if $options.visible:
		$options.hide()
	
#	$panel/list/continue.grab_focus()


func _on_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()



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


func _on_restart_pressed():
	global_data.playing = false
	player_data.reset_data()
	var next_node : PackedScene
	if OS.is_debug_build():
		next_node = global_data.game_debug_start
	else:
		next_node = global_data.game_start
	player_data.spawn_location = next_node.instance().get_node("player_spawn").position
	
	get_tree().paused = false
	queue_free()
	
	interactive_loader.go_to_level(next_node.get_path(), next_node.instance().get_node("player_spawn").position)
