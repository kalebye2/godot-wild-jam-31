extends Node2D


signal cam_limits_changed

onready var fade_color : Color = $bg/fade.color

func _ready() -> void:
	connect("cam_limits_changed", $player, "_on_cam_limits_changed")
	$fade_tween.interpolate_property($bg/fade, "color", fade_color, Color(fade_color.r, fade_color.g, fade_color.b, 0), .5)
	$fade_tween.start()
	
	if player_data.spawn_location != null:
		$player.position = player_data.spawn_location


func move_cam_limit(cam_limit_marker : Position2D, new_position : Vector2) -> void:
	cam_limit_marker.position = new_position
	emit_signal("cam_limits_changed")


func _on_checkpoint1_checkpoint_grabbed():
	move_cam_limit($cam_limit_left_top, $cam_new_limits.get_node("left_top/1").position)


func _on_checkpoint2_checkpoint_grabbed():
	move_cam_limit($cam_limit_right_bottom, $cam_new_limits.get_node("right_bottom/1").position)
	change_player_spawn_location($checkpoints/checkpoint2.position)


func change_player_spawn_location(pos : Vector2):
	player_data.spawn_location = pos


func _input(event):
	if event is InputEventKey && $player.state == $player.IDLE:
		if event.as_text() == "R":
			get_tree().reload_current_scene()
