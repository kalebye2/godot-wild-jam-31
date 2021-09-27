extends CanvasLayer

var _pause_menu : PackedScene = preload("res://src/ui/pause_menu.tscn")

signal player_entered
signal player_exited

func _ready():
	connect("player_entered", self, "_on_player_entered")
	connect("player_exited", self, "_on_player_exited")
	

#func _on_player_entered():
#	var node_pause_menu = _pause_menu.instance()
#	node_pause_menu.hide()
#	add_child(node_pause_menu)
#
#
#func _on_player_exited():
#	var node_pause_menu = get_node("ui")
#	if node_pause_menu != null:
#		node_pause_menu.queue_free()
