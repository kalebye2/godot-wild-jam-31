tool
extends Node2D

#export (Vector2) var initial_pos
onready var initial_pos : Vector2 = position
export (Vector2) var final_pos setget set_final_pos
export (float) var tween_time = 2.0

var tween_trans = Tween.TRANS_CUBIC
var tween_ease = Tween.EASE_IN_OUT


func _ready():
	if Engine.editor_hint:
		return
	else:
		$tween.interpolate_property(self, "position", initial_pos, position + final_pos, tween_time, tween_trans, tween_ease)
		$tween.start()


func _on_tween_tween_completed(object, key):
	if initial_pos + final_pos == position:
		$tween.interpolate_property(self, "position", initial_pos + final_pos, initial_pos, tween_time, tween_trans, tween_ease)
	else:
		$tween.interpolate_property(self, "position", initial_pos, position + final_pos, tween_time, tween_trans, tween_ease)
	$tween.start()


func _draw():
	if Engine.editor_hint:
		draw_circle(final_pos, 10, Color(.7, .3, .5, 1.0))

func set_final_pos(pos : Vector2):
	final_pos = pos
	update()
