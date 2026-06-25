class_name TeamGenerator
extends Control

var names: Names = Names.new()
var team: Team = Team.new()

func generate_league() -> League:
	var league: League = League.new()
	for x in Data._save.number_of_teams - 1:
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
	new_player.stats = generate_stats()
	var name_array: Array = generate_name()
	
	new_player.first_name = name_array[0]
	new_player.last_name = name_array[1]
	return new_player

func generate_stats() -> Stats:
	var new_stats: Stats = Stats.new()
	new_stats.agility = randi_range(40, 100)
	new_stats.charisma = randi_range(10, 100)
	new_stats.endurance = randi_range(50, 100)
	new_stats.intelligence = randi_range(40, 100)
	new_stats.strength = randi_range(20, 100)
	return new_stats

func generate_name() -> Array[String]:
	var num1: int = randi() % names.first_names.size()-1
	var num2: int = randi() % names.last_names.size()-1
	var name_array: Array[String]
	name_array.append(names.first_names[num1])
	name_array.append(names.last_names[num2])	
	return name_array
