extends Node

# ------------------
# --- Game State ---
# ------------------

@onready var team_generator = $TeamGenerator

var game: Game

func _ready() -> void:
	start_game()

func start_game():
	# used to get a different seed every time
	randomize()
	game = Game.new()
	game.team_1 = team_generator.generate_roster()
	game.team_1.players = team_generator.generate_players(13)
	game.team_2 = team_generator.generate_roster()
	game.team_2.players = team_generator.generate_players(13)
	print("--------------------------------------")
	print("--- Get ready for some basketball! ---")
	print("--------------------------------------")
	game.connect("print_to_gui", _handle_print_to_gui)
	game.possession_team = game.team_1 if randi_range(0,1) == 0 else game.team_2

	await game.start_possession()
	_handle_print_to_gui("") # Add a blank line between plays for readability

	# Simulate the first 10 possessions
	#while game.time_remaining_in_seconds > 0:
		### TODO Add better randomization here
		#await game.start_possession()
		#_handle_print_to_gui("") # Add a blank line between plays for readability

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
	await game.start_possession()
