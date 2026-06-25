class_name Team
extends Resource

@export var name: String
@export var players: Array
@export var city: String
@export var wins: int
@export var losses: int

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
