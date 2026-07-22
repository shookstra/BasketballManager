extends Node
class_name ShotCalculator

# Tunable weights
const W_S = 2.0
const W_A = 1.5
const W_I = 1.0
const W_D = 2.5
const W_F = 2.0
const BIAS = -1.0

static func shot_probability(player: Player, context: Dictionary) -> float:
	# context: {distance, defender_pressure (0-1)}
	var S = player.strength / 100.0
	var A = player.agility / 100.0
	var I = player.intelligence / 100.0
	var D = context.get("defender_pressure", 0.5)
	var F = player.fatigue

	var score_odds = W_S * S + W_A * A + W_I * I - W_D * D - W_F * F + BIAS
	# logistic
	var p = 1.0 / (1.0 + exp(-score_odds))
	return clamp(p, 0.01, 0.99)

static func resolve_shot(player: Player, context: Dictionary) -> bool:
	var p = shot_probability(player, context)
	return randf() < p
