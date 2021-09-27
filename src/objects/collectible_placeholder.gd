extends Node2D

func _ready():
	$tween.interpolate_property($sprite, "position", Vector2.ZERO, Vector2(0, 20), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()


func _on_tween_tween_completed(object, key):
	if object.position != Vector2.ZERO:
		$tween.interpolate_property(object, "position", object.position, Vector2.ZERO, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		$tween.interpolate_property($sprite, "position", Vector2.ZERO, Vector2(0, 20), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()
