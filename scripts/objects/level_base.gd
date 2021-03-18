extends Node2D

var pause_menu : PackedScene = preload("res://scene/ui/ui.tscn")


signal cam_limits_changed

onready var fade_color : Color = $bg/fade.color

func _ready() -> void:
	connect("cam_limits_changed", $player, "_on_cam_limits_changed")
	$fade_tween.interpolate_property($bg/fade, "color", fade_color, Color(fade_color.r, fade_color.g, fade_color.b, 0), .5)
	$fade_tween.start()
	
	if player_data.spawn_location != null:
		$player.position = player_data.spawn_location
	$player.direction = player_data.spawn_direction


func move_cam_limit(cam_limit_marker : Position2D, new_position : Vector2) -> void:
	cam_limit_marker.position = new_position
	emit_signal("cam_limits_changed")

func change_player_spawn_location(pos : Vector2):
	player_data.spawn_location = pos


func _input(event):
	if event.is_action_pressed("pause"):
		if $ui.get_child_count() == 0:
			$ui.add_child(pause_menu.instance())
		else:
			$ui.get_child(0).queue_free()
	
	if event is InputEventKey && $player.state == $player.IDLE:
		if event.as_text() == "R":
			get_tree().reload_current_scene()
