extends Node

# ------------------
# --- Game State ---
# ------------------

@onready var team_generator = $TeamGenerator
@onready var player_list_1 = $RosterModeTeam1
@onready var player_list_2 = $RosterModeTeam2

const player_card = preload("res://scenes/PlayerCard.tscn")

var game: Game

func _ready() -> void:
	start_game()

func start_game():
	# used to get a different seed every time
	randomize()
	game = Game.new()
	## TODO Replace with actual teams passed into this
	game.team_1 = team_generator.generate_roster()
	game.team_1.players = team_generator.generate_players(13)
	game.team_2 = team_generator.generate_roster()
	game.team_2.players = team_generator.generate_players(13)
	set_team_rosters()
	##
	print("--------------------------------------")
	print("--- Get ready for some basketball! ---")
	print("--------------------------------------")
	game.connect("print_to_gui", _handle_print_to_gui)
	game.possession_team = game.team_1 if randi_range(0,1) == 0 else game.team_2

func set_team_rosters():
	for player: Player in game.team_1.players:
		var new_card = player_card.instantiate()
		new_card.player = player
		new_card.get_node("HBoxContainer/NameLabel").text = player.first_name + " " + player.last_name
		new_card.get_node("HBoxContainer/StrengthLabel").text = str(player.strength)
		new_card.get_node("HBoxContainer/AgilityLabel").text = str(player.agility)
		new_card.get_node("HBoxContainer/EnduranceLabel").text = str(player.endurance)
		new_card.get_node("HBoxContainer/IntelligenceLabel").text = str(player.intelligence)
		new_card.get_node("HBoxContainer/CharismaLabel").text = str(player.charisma)
		player_list_1.add_child(new_card)

func _handle_print_to_gui(text):
	var new_label := Label.new()
	new_label.text = text
	$PlayByPlay/ScrollContainer/VBoxContainer.add_child(new_label)
	await get_tree().process_frame
	$PlayByPlay/ScrollContainer.ensure_control_visible(new_label)
	
func format_time(total_seconds: int) -> String:
	var m = total_seconds / 60
	var s = total_seconds % 60
	# %02d ensures the seconds are padded with a zero (e.g., 04 instead of 4)
	return "%02d:%02d" % [m, s]

func _on_next_play_button_pressed() -> void:
	if game.time_remaining_in_seconds > 0:
		await game.start_possession()

func _on_last_two_minutes_button_pressed() -> void:
	while game.time_remaining_in_seconds > 120:
		await game.start_possession()

func _on_end_of_game_button_pressed() -> void:
	while game.time_remaining_in_seconds > 0:
		await game.start_possession()
