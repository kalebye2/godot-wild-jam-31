extends Node

var spawn_map : String
var spawn_location : Vector2
var spawn_direction : int = 1

var spawn_init : bool = false

var seconds : int = 0
var minutes : int = 0

var collectibles : int = 0

var timer = Timer.new()

signal time_changed

func reset_data():
	if OS.is_debug_build():
		spawn_map = global_data.game_debug_start.get_path()
	else:
		spawn_map = global_data.game_start.get_path()
	timer.stop()
	seconds = 0
	minutes = 0
	timer.start()
	


func _ready():
	add_child(timer)
#	var timer = add_child(timer_var)
	timer.wait_time = 1.0
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()


func _on_timer_timeout():
	seconds += 1
	if seconds == 60:
		minutes += 1
		seconds = 0
	emit_signal("time_changed")
