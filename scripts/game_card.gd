extends Control
class_name GameCard

signal set_game(game: Game)

@export var team_1: Team
@export var team_2: Team
@export var game: Game = Game.new()

@onready var team1_name_label = $HBoxContainer/Team1Container/Team1Label
@onready var team1_record_label = $HBoxContainer/Team1Container/Team1RecordLabel
@onready var team2_name_label = $HBoxContainer/Team2Container/Team2Label
@onready var team2_record_label = $HBoxContainer/Team2Container/Team2RecordLabel

func _ready() -> void:
	team1_name_label.text = team_1.name
	team1_record_label.text = str(team_1.wins) + "-" + str(team_1.losses)
	
	team2_name_label.text = team_2.name
	team2_record_label.text = str(team_2.wins) + "-" + str(team_2.losses)
	game.team_1 = team_1
	game.team_2 = team_2


func _on_open_game_button_pressed() -> void:
	emit_signal("set_game", game)
