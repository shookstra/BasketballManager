class_name Player
extends Resource

@export var first_name: String
@export var last_name: String
@export var stats: Stats
@export var position: String
@export var age: int

func _init(new_first_name = "Default First Name", new_last_name = "Default Last Name", new_stats = Stats.new(), new_position = "Forward", new_age = 21):
	first_name = new_first_name
	last_name = new_last_name
	stats = new_stats
	position = new_position
	age = new_age
