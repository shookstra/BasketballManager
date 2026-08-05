class_name Game
extends Resource

signal print_to_gui

@export var team_1: Team = Team.new()
@export var team_2: Team = Team.new()
@export var possession_team: Team
@export var possession_player: Player
@export var team_1_score: int
@export var team_2_score: int
@export var time_remaining_in_seconds: int = 2400 # 40 minutes * 60 seconds
@export var shot_clock: int = 25
@export var rng_seed = randi()

func _ready():
	randomize()
	possession_team = team_1 if 0 == randi_range(0,1) else team_2
	start_possession()

func start_possession():
	shot_clock = 25
	emit_print_to_gui(str("Offensive Team: " + possession_team.name))
	if time_remaining_in_seconds > 0:
		possession_step()

func possession_step():
	if possession_player == null:
		possession_player = possession_team.get_ball_handler()
		emit_print_to_gui("### Player: " + possession_player.get_full_name())
	var context = {
		"shot_clock": shot_clock,
		"defender_distance": randf_range(0.5, 4.0),
		"defender_pressure": randf()
	}
	var decision = decide(possession_player, context)
	match decision.action:
		"shoot":
			emit_print_to_gui(str("%s shoots the ball..." % possession_player.get_full_name()))
			var made = ShotCalculator.resolve_shot(possession_player, context)
			handle_shot_result(possession_player, made)
			advance_clock(randi_range(2,5))
		"drive":
			emit_print_to_gui("%s drives..." % possession_player.get_full_name())
			advance_clock(randi_range(2,5))
			if randf() < 0.6:
				var made2 = ShotCalculator.resolve_shot(possession_player, context)
				handle_shot_result(possession_player, made2)
			else:
				turnover()
		"pass":
			var target = possession_team.find_best_receiver()
			emit_print_to_gui("%s passes the ball to %s." % [possession_player.get_full_name(), target.get_full_name()])
			handle_pass(target)
			advance_clock(2)
			emit_print_to_gui("### Player: %s" % possession_player.get_full_name())
		"reset":
			shot_clock -= 4
			advance_clock(2.0)
			# schedule next step instead of calling directly
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
		emit_print_to_gui("%s scores!!" % player.get_full_name())
		award_points(2)
		# schedule possession change instead of immediate recursion
		change_possession()
		print_game_info()
	else:
		emit_print_to_gui("%s misses :/" % player.get_full_name())
		advance_clock(2)
		# simple rebound resolution
		if randf() < 0.5:
			advance_clock(1)
			var rebounder: Player = possession_team.find_best_rebounder()
			emit_print_to_gui(rebounder.get_full_name() + " grabs the offensive rebound.")
			possession_player = rebounder
			emit_print_to_gui("### Player: " + rebounder.get_full_name())
			# schedule next possession step
			possession_step()
		else:
			emit_print_to_gui("Defensive rebound")
			advance_clock(7)
			change_possession()


func turnover():
	advance_clock(7)
	emit_print_to_gui("Turnover :(")
	change_possession()
	
func change_possession():
	possession_player = null
	possession_team = team_1 if possession_team == team_2 else team_2
	print_game_info()
	# schedule start_possession instead of calling it directly
	#call_deferred("start_possession")
	
func advance_clock(seconds):
	self.time_remaining_in_seconds -= seconds
	# update fatigue for players on court
	for p in team_1.players_playing:
		p.update_fatigue(seconds)
	for p in team_2.players_playing:
		p.update_fatigue(seconds)
		
func handle_pass(target_player: Player):
	possession_player = target_player
	# after a pass, schedule the next decision step
	possession_step()
	
func print_game_info():
	emit_print_to_gui("--------------------------------------------------------")
	emit_print_to_gui("### " + team_1.name + " " + str(team_1_score) + " Time:" + str(time_remaining_in_seconds) + " " + team_2.name + " " + str(team_2_score) + " -")
	emit_print_to_gui("--------------------------------------------------------")
	
func award_points(amount: int):
	if possession_team == team_1:
		team_1_score += amount
	else:
		team_2_score += amount

func emit_print_to_gui(text: String):
	emit_signal("print_to_gui", text)
