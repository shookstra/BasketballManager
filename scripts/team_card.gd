class_name TeamCard
extends Control

signal team_selected(team: Team)

@export var team: Team

func _on_button_pressed() -> void:
	team_selected.emit(self)
