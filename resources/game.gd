class_name Game
extends Resource

var team_1: Team = Team.new()
var team_2: Team = Team.new()
var possesion_team: Team
var team_1_score: int
var team_2_score: int
var time_remaining_in_seconds: int = 2880 # 48 minutes * 60 seconds
var shot_clock: int = 24
var rng_seed = randi()

var possession_team: Team

func _ready():
	randomize()
	possession_team = team_1
	start_possession()

func start_possession():
	shot_clock = 24
	possession_step()

func possession_step():
	# pick ball handler (simple: best ball handler)
	var ball_handler = possession_team.get_ball_handler()
	var context = {
		"shot_clock": shot_clock,
		"defender_distance": randf_range(0.5, 4.0),
		"defender_pressure": randf()
	}
	var decision = ball_handler.request_action(context)
	match decision.action:
		"shoot":
			var made = ShotCalculator.resolve_shot(ball_handler, context)
			handle_shot_result(ball_handler, made)
		"drive":
			# simplified: drive leads to contested shot or pass
			if randf() < 0.6:
				var made2 = ShotCalculator.resolve_shot(ball_handler, context)
				handle_shot_result(ball_handler, made2)
			else:
				turnover()
		"pass":
			var target = possession_team.find_best_receiver(ball_handler)
			## TODO Handle pass logic
			#_handle_pass(ball_handler, target)
		"reset":
			shot_clock -= 4
			advance_clock(1.0)
			possession_step()

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
		print("%s scores" % player.name)
		end_possession()
	else:
		print("%s misses" % player.name)
		# simple rebound resolution
	if randf() < 0.5:
		print("Offensive rebound")
		possession_step()
	else:
		print("Defensive rebound")
		change_possession()

func turnover():
	print("Turnover")
	change_possession()
	
func change_possession():
	possession_team = team_1 if possession_team == team_2 else team_2
	start_possession()
	
func end_possession():
	# update stats, reset shot clock, alternate possession
	change_possession()
	

func advance_clock(seconds):
	# update fatigue for players on court
	for p in team_1.get_on_court_players():
		p.update_fatigue(seconds)
	for p in team_2.get_on_court_players():
		p.update_fatigue(seconds)
