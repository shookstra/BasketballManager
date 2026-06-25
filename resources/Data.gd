extends Node

# We always keep a reference to the SaveGameAsResource resource here to prevent it from unloading.
var _save := SaveGameAsResource.new()

func _create_or_load_save() -> void:
	if SaveGameAsResource.save_exists():
		_save = SaveGameAsResource.load_savegame()
	else:
		_save = SaveGameAsResource.new()
		_save.write_savegame()
		
func _save_game() -> void:
	_save.write_savegame()
