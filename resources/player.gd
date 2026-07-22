class_name Player
extends Resource

@export var first_name: String
@export var last_name: String
@export var position: String
@export var age: int
@export var fatigue: int

@export_range(1, 99) var shooting_skill: int
@export_range(1, 99) var pass_quality: int
@export_range(1, 99) var decision_speed: int
@export_range(1, 99) var rebounding: int
@export_range(1, 99) var defense: int
# 
@export var strength: int
@export var agility: int
@export var endurance: int
@export var intelligence: int
@export var charisma: int
#
@export var minutes_played: float
@export var total_points: int
@export var average_points: float
@export var total_rebounds: int
@export var average_rebounds: float
@export var total_assists: int
@export var average_assists: float


func _init(new_first_name = "Default First Name", new_last_name = "Default Last Name", new_position = "Forward", new_age = 21):
	first_name = new_first_name
	last_name = new_last_name
	position = new_position
	age = new_age
	calculate_derived_stats()
	
func get_full_name():
	return str(self.first_name + " " + self.last_name)
	
# calculate shooting %, pass quality, etc using primary stats
func calculate_derived_stats():
	self.shooting_skill = int((self.strength * 0.3 + self.agility * 0.5 + self.intelligence * 0.2) / 100)
	self.pass_quality = int(self.charisma / 100.0)
	self.decision_speed = int(self.intelligence / 100.0)
	
func update_fatigue(delta_time: float):
	# fatigue increases with time on court, reduced by endurance
	fatigue += int(delta_time * (1.0 - self.endurance / 150.0))
	fatigue = clamp(fatigue, 0.0, 1.0)
