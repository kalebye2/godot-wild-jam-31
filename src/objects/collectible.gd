extends Node2D

var collected : bool = false


func _ready():
	$tween.interpolate_property($sprite, "position", Vector2.ZERO, Vector2(0, 20), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()


func _on_tween_tween_completed(object, key):
	if object.position != Vector2.ZERO:
		$tween.interpolate_property(object, "position", object.position, Vector2.ZERO, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		$tween.interpolate_property($sprite, "position", Vector2.ZERO, Vector2(0, 20), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()


func _on_area_2d_area_entered(area):
	if area.name == "checkpoint_checker" && collected == false:
		$collected.play()
		collected = true
		player_data.emit_signal("collectible_collected", get_parent().get_parent().name, name)
		$sprite.hide()
		$collected_particles.show()
		$collected_particles.emitting = true
		$timer.start()


func _on_timer_timeout():
	queue_free()
