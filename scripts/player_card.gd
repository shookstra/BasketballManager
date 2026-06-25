class_name PlayerCard
extends Control

signal player_selected(player: Player)

@export var player: Player

@onready var name_label = $HBoxContainer/NameLabel
@onready var strength_label = $HBoxContainer/StrengthLabel


func _on_button_pressed() -> void:
	player_selected.emit(self)
