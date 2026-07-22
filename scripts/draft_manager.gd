class_name DraftManager
extends Control
	
func simulate_draft_pick() -> Player:
	# start with a default player
	var highest_average_player: Player = Player.new()
	for current_player: Player in Data._save.players:
		# get the average for each player
		var current_player_average: int = (current_player.agility + current_player.charisma + current_player.endurance + current_player.intelligence + current_player.strength)/5
		# if the average of the current player > highest_average_player then replace the player
		var highest_player_average: int = (highest_average_player.agility + highest_average_player.charisma + highest_average_player.endurance + highest_average_player.intelligence + highest_average_player.strength)/5
		if current_player_average > highest_player_average:
			highest_average_player = current_player
	return highest_average_player
