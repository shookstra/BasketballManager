class_name Draft
extends Resource

@export var current_round: int = 1
@export var current_pick_number: int = 1
@export var picks: Array[DraftPick] = []
@export var draft_order: Array[Team] = []
@export var current_team: Team = Team.new()
