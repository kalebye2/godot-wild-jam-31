extends Node

var spawn_map : String
var spawn_location : Vector2
var spawn_direction : int = 1

var spawn_init : bool = false

var seconds : int = 0
var minutes : int = 0

var collectibles : int = 0
const TOTAL_COLLECTIBLES : int = 10
var dict_collectibles : Dictionary = {}
var deaths : int = 0

var timer = Timer.new()

# persistent data
var minutes_no_collectibles : int
var minutes_collectibles : int
var seconds_no_collectibles : int
var seconds_collectibles : int

signal time_changed
signal collectible_collected(level, node_name)

func reset_data():
	dict_collectibles.clear()
	if OS.is_debug_build():
		spawn_map = global_data.game_debug_start.get_path()
	else:
		spawn_map = global_data.game_start.get_path()
	timer.stop()
	seconds = 0
	minutes = 0
	deaths = 0
	timer.start()
	


func _ready():
	# collectible signal
	connect("collectible_collected", self, "_on_collectible_collected")
	
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


func _on_collectible_collected(level, node_name):
	collectibles += 1
	dict_collectibles[level].append(node_name)
