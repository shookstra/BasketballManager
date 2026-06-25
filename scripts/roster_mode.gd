extends Control

@export var team: Team

@onready var player_list = $PlayerList/ScrollContainer/VBoxContainer

const player_card = preload("res://scenes/PlayerCard.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func set_team():
	for player: Player in team.players:
		var new_card = player_card.instantiate()
		new_card.player = player
		new_card.get_node("HBoxContainer/NameLabel").text = player.first_name + " " + player.last_name
		new_card.get_node("HBoxContainer/StrengthLabel").text = str(player.stats.strength)
		new_card.get_node("HBoxContainer/AgilityLabel").text = str(player.stats.agility)
		new_card.get_node("HBoxContainer/EnduranceLabel").text = str(player.stats.endurance)
		new_card.get_node("HBoxContainer/IntelligenceLabel").text = str(player.stats.intelligence)
		new_card.get_node("HBoxContainer/CharismaLabel").text = str(player.stats.charisma)
		player_list.add_child(new_card)

func clear_team():
	for child in player_list.get_children():
		child.queue_free()
