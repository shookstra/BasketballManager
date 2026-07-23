class_name Team
extends Resource

@export var name: String
@export var players: Array
@export var players_playing: Array[Player]
@export var city: String
@export var wins: int
@export var losses: int
@export var schedule: Array[Game]

var cities = [
	"Lincoln",
	"El Segundo",
	"West Seneca",
	"Laurel",
	"Duluth",
	"Vineyard",
	"North Hollywood",
	"Eloy",
	"Dunedin",
	"Stanton",
	"Simpsonville",
	"Eastpointe",
	"San Francisco",
	"Medford"
]
var states = ['Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','Florida','Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin','Wyoming']
var names = [
	"Bruisers",
	"Cruisers",
	"Falcons",
	"Raptors",
	"Tempest",
	"Galactics",
	"Blazers",
	"Surge",
	"Blast",
	"Crushers",
	"Vortex",
	"Pioneers",
	"Storm",
	"Sugargliders",
	"Bouncers",
	"Cougars",
	"Stingers",
	"Wraiths"]
	
func _init(new_name = "Default Name", new_players = [], new_city = "Default City"):
	name = new_name
	players = new_players
	city = new_city
	
func get_ball_handler():
	return players[randi_range(0,4)]
	## TODO Loop through players and return the best ball handler
	#for player in players:
		#pass
		
func find_best_receiver():
	return players[randi_range(0,4)]
	## TODO Loop through players and return the best receiver
	#for player in players:
		#pass
		
func find_best_rebounder():
	return players[randi_range(0,4)]
	## TODO Loop through players and return the best rebounder
	#for player in players:
		#pass
