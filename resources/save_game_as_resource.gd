class_name SaveGameAsResource
extends Resource

@export var selected_player: Player = Player.new()
@export var draft: Draft = Draft.new()
@export var number_of_teams: int = 6
@export var number_of_games: int = 82
@export var league: League = League.new()
@export var players: Array[Player] = []
@export var player_team: Team = Team.new()
@export var current_team: Team = Team.new()

const SAVE_GAME_BASE_PATH := "res://saves/save"

func write_savegame() -> void:
	ResourceSaver.save(self, get_save_path())

static func save_exists() -> bool:
	return ResourceLoader.exists(get_save_path())

static func load_savegame() -> Resource:
	var save_path := get_save_path()
	return ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_IGNORE)

static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_BASE_PATH + extension
