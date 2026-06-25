class_name Stats
extends Resource

@export var strength: int
@export var agility: int
@export var endurance: int
@export var intelligence: int
@export var charisma: int
@export var minutes_played: float
@export var total_points: int
@export var average_points: float
@export var total_rebounds: int
@export var average_rebounds: float
@export var total_assists: int
@export var average_assists: float


func _init(new_strength = 0, new_agility = 0, new_endurance = 0, new_intelligence = 0, new_charisma = 0):
	strength = new_strength
	agility = new_agility
	endurance = new_endurance
	intelligence = new_intelligence
	charisma = new_charisma
