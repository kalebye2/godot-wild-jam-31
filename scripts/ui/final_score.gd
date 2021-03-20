extends Node2D

func _ready():
	# final message to player
	var message : String
	if player_data.collectibles == player_data.TOTAL_COLLECTIBLES && player_data.deaths == 0 && player_data.minutes < 3:
		message = "How did you do that?"
	elif player_data.collectibles == 7 && player_data.deaths == 0:
		message = "Perfect!"
	elif player_data.collectibles == 0:
		message = "Not even the given one?"
	elif player_data.deaths == 0:
		message = "Parkour Life"
	elif player_data.collectibles == player_data.TOTAL_COLLECTIBLES:
		message = "Oregano'd"
	elif player_data.collectibles == player_data.TOTAL_COLLECTIBLES - 1:
		message = "Almost sauce"
	elif (player_data.minutes < 5 && player_data.collectibles == 7):
		message = "Speedrunner"
	elif player_data.minutes < 5:
		message = "Gotta go fast"
	else:
		message = "Good job!"
	$label.text = message
	
	$oregano/oregano_label.text = "%d/%d" % [player_data.collectibles, player_data.TOTAL_COLLECTIBLES]
	$deaths/deaths_label.text = "x%02d" % player_data.deaths
	$time/time_label.text = "%d:%02d" % [player_data.minutes, player_data.seconds]
