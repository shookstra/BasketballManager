extends Node

# ------------------
# --- Game State ---
# ------------------

@onready var team_generator = $TeamGenerator
@onready var game: Game = Game.new()
# --- 2. Team Profiles (Stats are out of 100 for easy probability) ---


func _ready() -> void:
	# used to get a different seed every time
	randomize()
	game.team_1 = team_generator.generate_roster()
	game.team_1.players = team_generator.generate_players(13)
	game.team_2 = team_generator.generate_roster()
	game.team_2.players = team_generator.generate_players(13)
	
	print("--------------------------------------")
	print("--- Get ready for some basketball! ---")
	print("--------------------------------------")
	
	# Simulate the first 10 possessions
	for i in range(10):
		game.start_possession()
		print("") # Add a blank line between plays for readability

func format_time(total_seconds: int) -> String:
	var m = total_seconds / 60
	var s = total_seconds % 60
	# %02d ensures the seconds are padded with a zero (e.g., 04 instead of 4)
	return "%02d:%02d" % [m, s]
