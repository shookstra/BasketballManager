extends Control

const player_card = preload("res://scenes/PlayerCard.tscn")
const team_card = preload("res://scenes/TeamCard.tscn")

@onready var league_name_line_edit = $NewLeagueMode/VBoxContainer/LeagueNameLineEdit
@onready var city_line_edit = $NewLeagueMode/VBoxContainer/CityLineEdit
@onready var team_name_line_edit = $NewLeagueMode/VBoxContainer/TeamNameLineEdit
@onready var gm_line_edit = $NewLeagueMode/VBoxContainer/GMLineEdit
@onready var team_generator: TeamGenerator
@onready var draft_manager: DraftManager
@onready var draft_picks_window := $DraftMode/DraftPicksWindow/ScrollContainer/VBoxContainer
@onready var roster_mode := $NewLeagueMode/RosterMode

var save := SaveGameAsResource.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data._create_or_load_save()
	set_draft_picks()
	team_generator = TeamGenerator.new()
	draft_manager = DraftManager.new()
		
	if (Data._save.league.teams.size() < Data._save.number_of_teams):
		while (Data._save.league.teams.size() < Data._save.number_of_teams):
			var new_team = team_generator.generate_roster()
			Data._save.league.teams.append(new_team)
	$Dashboard/SidebarColorRect2/TeamNameLabel.text = Data._save.player_team.city + " " + Data._save.player_team.name
	
	if (!Data._save.players):
		Data._save.players = team_generator.generate_players(100)
		
	set_list_of_teams()
	set_available_players_list()

func set_available_players_list():
	var container = $DraftMode/AvailablePlayers/ScrollContainer/VBoxContainer
	for n in container.get_children():
		container.remove_child(n)
		n.queue_free()
		
	for new_player in Data._save.players:
		var new_card = player_card.instantiate()
		new_card.player = new_player
		new_card.get_node("HBoxContainer/NameLabel").text = new_player.first_name + " " + new_player.last_name
		new_card.get_node("HBoxContainer/StrengthLabel").text = str(new_player.stats.strength)
		new_card.get_node("HBoxContainer/AgilityLabel").text = str(new_player.stats.agility)
		new_card.get_node("HBoxContainer/EnduranceLabel").text = str(new_player.stats.endurance)
		new_card.get_node("HBoxContainer/IntelligenceLabel").text = str(new_player.stats.intelligence)
		new_card.get_node("HBoxContainer/CharismaLabel").text = str(new_player.stats.charisma)
		$DraftMode/AvailablePlayers/ScrollContainer/VBoxContainer.add_child(new_card)
		new_card.connect("player_selected", _on_player_selected)
		
func set_roster():
	pass

func _on_create_league_button_pressed() -> void:
	var new_league = team_generator.generate_empty_league()
	new_league.league_name = league_name_line_edit.text
	new_league.general_manager = gm_line_edit.text
	
	var new_team: Team = Team.new()
	new_team.city = city_line_edit.text
	new_team.name = team_name_line_edit.text
	
	new_league.teams.append(new_team)
	
	Data._save.league = new_league
	Data._save.player_team = new_team
	Data._save_game()

# show available players
func _on_draft_button_pressed() -> void:
	$DraftMode.visible = true
	$NewLeagueMode.visible = false
	$LeagueMode.visible = false

func _on_league_button_pressed() -> void:
	$DraftMode.visible = false
	$NewLeagueMode.visible = true
	$LeagueMode.visible = false
	
func _on_player_selected(new_player_card: PlayerCard):
	Data._save.selected_player = new_player_card.player
	$DraftMode/SelectedPlayer/SelectedPlayerLabel.text = Data._save.selected_player.first_name + " " + Data._save.selected_player.last_name

func _on_team_selected(new_team_card: TeamCard):
	roster_mode.team = new_team_card.team
	roster_mode.clear_team()
	roster_mode.set_team()
	

func set_list_of_teams():
	for new_team in Data._save.league.teams:
		var new_team_card = team_card.instantiate()
		new_team_card.team = new_team
		new_team_card.get_node("HBoxContainer/NameLabel").text = new_team.city + " " + new_team.name
		new_team_card.get_node("HBoxContainer/WinsLabel").text = str(new_team.wins)
		new_team_card.get_node("HBoxContainer/LossesLabel").text = str(new_team.losses)
		new_team_card.connect("team_selected", _on_team_selected)
		$NewLeagueMode/TeamList/ScrollContainer/VBoxContainer.add_child(new_team_card)

func _on_confirm_pick_button_pressed() -> void:
	if Data._save.draft.current_round < 14:
		var selected_player = Data._save.selected_player
		if selected_player:
			var draft_pick := DraftPick.new()
			Data._save.player_team.players.append(selected_player)
			Data._save.players.erase(selected_player)
			draft_pick.player = selected_player
			draft_pick.team = Data._save.player_team
			draft_pick.pick_number = Data._save.draft.current_pick_number
			draft_pick.round_number = Data._save.draft.current_round
			Data._save.draft.picks.append(draft_pick)
			
			Data._save.draft.current_pick_number += 1
			
			set_available_players_list()
			
			for team in Data._save.league.teams:
				if team != Data._save.player_team:
					var new_pick: Player = draft_manager.simulate_draft_pick()
					var computer_draft_pick := DraftPick.new()
					computer_draft_pick.player = new_pick
					computer_draft_pick.team = team
					computer_draft_pick.pick_number = Data._save.draft.current_pick_number
					computer_draft_pick.round_number = Data._save.draft.current_round
					Data._save.draft.picks.append(computer_draft_pick)
					team.players.append(new_pick)
					Data._save.players.erase(new_pick)
					var new_label := Label.new()
					Data._save.draft.current_pick_number += 1
					set_draft_picks()
					#print(team.name + " selected: " + new_pick.first_name + " " + new_pick.last_name)
			Data._save.draft.current_round += 1
			Data._save.draft.current_pick_number = 1
			Data._save_game()
			
		Data._save.selected_player = null

func set_draft_picks():
	for item in draft_picks_window.get_children():
		item.queue_free()
	
	for draft_pick in Data._save.draft.picks:
		var new_label = Label.new()
		new_label.text = "Round " + str(draft_pick.round_number) + " Pick " + str(draft_pick.pick_number) + " - " + draft_pick.team.city + " " + draft_pick.team.name + " selected " + draft_pick.player.first_name + " " + draft_pick.player.last_name
		draft_picks_window.add_child(new_label)

func _on_save_game_button_pressed() -> void:
	Data._save_game()
