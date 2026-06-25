class_name DraftManager
extends Control
	
func simulate_draft_pick() -> Player:
	# start with a default player
	var highest_average_player: Player = Player.new()
	for current_player: Player in Data._save.players:
		# get the average for each player
		var current_player_average: int = (current_player.stats.agility + current_player.stats.charisma + current_player.stats.endurance + current_player.stats.intelligence + current_player.stats.strength)/5
		# if the average of the current player > highest_average_player then replace the player
		var highest_player_average: int = (highest_average_player.stats.agility + highest_average_player.stats.charisma + highest_average_player.stats.endurance + highest_average_player.stats.intelligence + highest_average_player.stats.strength)/5
		if current_player_average > highest_player_average:
			highest_average_player = current_player
	return highest_average_player
