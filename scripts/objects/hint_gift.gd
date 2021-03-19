extends Node2D

export (String) var hint_text

var initial_textbox_size : Vector2 = Vector2.ZERO
var final_textbox_size : Vector2 = Vector2.ONE
var tween_time : float = .5

var tween_trans : int = Tween.TRANS_BACK
var tween_ease : int = Tween.EASE_OUT
var tween_ease_alt : int = Tween.EASE_IN

signal player_entered
signal player_exited

func _ready():
	$panel/label.text = hint_text
	$panel.rect_pivot_offset = $panel.rect_size / 2
	$panel.hide()


func _on_hint_gift_player_entered():
	$panel.show()
	$tween.interpolate_property($panel, "rect_scale", initial_textbox_size, final_textbox_size, tween_time, tween_trans, tween_ease)
	$tween.start()


func _on_hint_gift_player_exited():
	$tween.interpolate_property($panel, "rect_scale", final_textbox_size, initial_textbox_size, tween_time, tween_trans, tween_ease_alt)
	$tween.start()


func _on_tween_tween_completed(object, key):
	if object is Panel && object.rect_size == Vector2.ZERO:
		object.hide()
