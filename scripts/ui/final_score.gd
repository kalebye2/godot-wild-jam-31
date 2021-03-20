extends Node2D


func _ready():
	$oregano/oregano_label.text = "%d/%d" % [player_data.collectibles, player_data.TOTAL_COLLECTIBLES]
	$deaths/deaths_label.text = "x%02d" % player_data.deaths
	$time/time_label.text = "%d:%02d" % [player_data.minutes, player_data.seconds]
