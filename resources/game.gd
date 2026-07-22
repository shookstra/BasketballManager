class_name Game
extends Resource

enum States { IDLE, START_POSSESSION, DECIDE, RESOLVE_ACTION, HANDLE_SHOT, CHANGE_POSSESSION, END_GAME }
var state: States = States.IDLE


var team_1: Team = Team.new()
var team_2: Team = Team.new()
var possession_team: Team
var possession_player: Player
var team_1_score: int
var team_2_score: int
var time_remaining_in_seconds: int = 2880 # 48 minutes * 60 seconds
var shot_clock: int = 25
var rng_seed = randi()

func _ready():
	randomize()
	possession_team = team_1 if 0 == randi_range(0,1) else team_2
	start_possession()

func start_possession():
	shot_clock = 25
	state = States.START_POSSESSION
	if time_remaining_in_seconds > 0:
		call_deferred("possession_step")

func possession_step():
	# pick ball handler (simple: best ball handler)
	possession_player = possession_team.get_ball_handler()
	var context = {
		"shot_clock": shot_clock,
		"defender_distance": randf_range(0.5, 4.0),
		"defender_pressure": randf()
	}
	var decision = decide(possession_player, context)
	match decision.action:
		"shoot":
			print("%s shoots the ball..." % possession_player.get_full_name())
			var made = ShotCalculator.resolve_shot(possession_player, context)
			handle_shot_result(possession_player, made)
		"drive":
			print("%s drives..." % possession_player.get_full_name())
			if randf() < 0.6:
				var made2 = ShotCalculator.resolve_shot(possession_player, context)
				handle_shot_result(possession_player, made2)
			else:
				turnover()
				print_game_info()
		"pass":
			var target = possession_team.find_best_receiver()
			print("%s passes the ball to %s." % [possession_player.get_full_name(), target.get_full_name()])
			handle_pass(target)
		"reset":
			shot_clock -= 4
	advance_clock(10)
			#possession_step()

static func decide(player: Player, context: Dictionary) -> Dictionary:
	# compute utilities for actions: shoot, drive, pass, reset
	var dist = context.get("defender_distance", 2.0) # meters
	var shot_clock = context.get("shot_clock", 24)
	var fatigue_penalty = player.fatigue * 1.5
	
	var shoot_score = player.shooting_skill * 3.0 + (-1.0 if dist > 3.0 else 0.5) - fatigue_penalty
	var drive_score = player.agility/100.0 * 2.0 + player.strength/100.0 - fatigue_penalty
	var pass_score = player.pass_quality * 2.5 + player.intelligence/100.0 - fatigue_penalty
	var reset_score = 0.5 + (-1.0 if shot_clock < 6 else 0.0)
	
	var scores = [shoot_score, drive_score, pass_score, reset_score]
	var choice = get_soft_max(scores)
	var actions = ["shoot","drive","pass","reset"]
	return {"action": actions[choice], "scores": scores}
	
static func get_soft_max(scores: Array) -> int:
	var max_s = -INF
	for s in scores: max_s = max(max_s, s)
	var exps = []
	var sum = 0.0
	for s in scores:
		var e = exp(s - max_s)
		exps.append(e)
		sum += e
	var r = randf() * sum
	var acc = 0.0
	for i in range(exps.size()):
		acc += exps[i]
		if r <= acc:
			return i
	return exps.size() - 1
	
func handle_shot_result(player, made):
	if made:
		print("%s scores!!" % player.get_full_name())
		award_points(2)
		change_possession()
		print_game_info()
	else:
		print("%s misses :/" % player.get_full_name())
		# simple rebound resolution
	if randf() < 0.5:
		print("Offensive rebound")
		possession_step()
	else:
		print("Defensive rebound")
		change_possession()

func turnover():
	print("Turnover :(")
	change_possession()
	
func change_possession():
	possession_team = team_1 if possession_team == team_2 else team_2
	start_possession()

func advance_clock(seconds):
	self.time_remaining_in_seconds = time_remaining_in_seconds - seconds
	# update fatigue for players on court
	for p in team_1.players_playing:
		p.update_fatigue(seconds)
	for p in team_2.players_playing:
		p.update_fatigue(seconds)
		
func handle_pass(target_player: Player):
	possession_player = target_player
	
func print_game_info():
	#var team_1: Team = Team.new()
	#var team_2: Team = Team.new()
	#var possession_team: Team
	#var possession_player: Player
	#var team_1_score: int
	#var team_2_score: int
	#var time_remaining_in_seconds: int = 2880 # 48 minutes * 60 seconds
	#var shot_clock: int = 25
	#var rng_seed = randi()
	
	print("---------------------------------")
	print("Team_1 %x %x Team_2 %x" % [int(team_1_score), int(time_remaining_in_seconds/60), int(team_2_score)])
	print("---------------------------------")
	
func award_points(amount: int):
	if possession_team == team_1:
		team_1_score += amount
	else:
		team_2_score += amount
