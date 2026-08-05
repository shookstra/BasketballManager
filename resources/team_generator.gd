class_name TeamGenerator
extends Control

var names: Names = Names.new()
var team: Team = Team.new()

func generate_schedule() -> Schedule:
	var total_number_of_games = Data._save.number_of_teams * Data._save.number_of_games
	var new_schedule = Schedule.new()
	for team in Data._save.league.teams:
		for game_number in Data._save.league.teams.size():
			var teams = Data._save.league.teams
			var new_game = Game.new()
			new_game.team_1 = team
			# if they're the same team then go to the next team
			if team != teams[game_number]:
				new_game.team_1 = team
				new_game.team_2 = teams[game_number]
				new_schedule.games.append(new_game)
				print(new_game.team_1.name + " Vs. " + new_game.team_2.name)
	new_schedule.games.shuffle()
	return new_schedule

func generate_league() -> League:
	var league: League = League.new()
	for x in Data._save.number_of_teams - 1:
		var new_team = generate_roster()
		for team in league.teams:
			while team.name == new_team.name:
				new_team = generate_roster()
		league.teams.append(generate_roster())
	return league

func generate_roster() -> Team:
	var new_team: Team = Team.new()
	var name_index: int = randi() % new_team.names.size()
	var city_index: int = randi() % new_team.cities.size()
	
	new_team.name = new_team.names[name_index]
	new_team.city = new_team.cities[city_index]
	
	for x in 13:
		var new_player_index = randi_range(0, Data._save.players.size()-1)
		if (Data._save.players.size() > 0):
			new_team.players.append(Data._save.players[new_player_index])
	
	return new_team

func generate_empty_league() -> League:
	var league: League = League.new()
	for x in Data._save.number_of_teams - 1:
		league.teams.append(generate_empty_team())
	return league

func generate_empty_team() -> Team:
	var new_team: Team = Team.new()
	var name_index: int = randi() % new_team.names.size()
	var city_index: int = randi() % new_team.cities.size()
	
	new_team.name = new_team.names[name_index]
	new_team.city = new_team.cities[city_index]
	
	return new_team

func generate_players(amount) -> Array[Player]:
	var new_players: Array[Player]
	for x in amount:
		new_players.append(generate_player())
	return new_players

func generate_player() -> Player:
	var new_player: Player = Player.new()
	new_player = generate_stats(new_player)
	var name_array: Array = generate_name()
	
	new_player.first_name = name_array[0]
	new_player.last_name = name_array[1]
	return new_player

func generate_stats(player: Player) -> Player:
	player.agility = randi_range(40, 100)
	player.charisma = randi_range(10, 100)
	player.endurance = randi_range(50, 100)
	player.intelligence = randi_range(40, 100)
	player.strength = randi_range(20, 100)
	return player

func generate_name() -> Array[String]:
	var num1: int = randi() % names.first_names.size()-1
	var num2: int = randi() % names.last_names.size()-1
	var name_array: Array[String]
	name_array.append(names.first_names[num1])
	name_array.append(names.last_names[num2])	
	return name_array
