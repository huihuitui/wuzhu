extends Node

## Singleton responsible for loading and hot reloading JSON-driven data.

var weapons_data: Dictionary = {}
var enemies_data: Dictionary = {}
var drop_tables_data: Dictionary = {}

func _ready() -> void:
	load_all()

func load_all() -> void:
	weapons_data = _load_json_file("res://data/weapons.json")
	enemies_data = _load_json_file("res://data/enemies.json")
	drop_tables_data = _load_json_file("res://data/drop_tables.json")

func reload(path: String) -> void:
	match path:
		"weapons":
			weapons_data = _load_json_file("res://data/weapons.json")
		"enemies":
			enemies_data = _load_json_file("res://data/enemies.json")
		"drop_tables":
			drop_tables_data = _load_json_file("res://data/drop_tables.json")
		_:
			push_warning("Unknown reload target: %s" % path)

func _load_json_file(path: String):
	var result = {}
	if not FileAccess.file_exists(path):
		push_warning("Missing data file: %s" % path)
		return result
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Unable to open data file: %s" % path)
		return result
	var content := file.get_as_text()
	var parsed: Variant = JSON.parse_string(content)
	if parsed == null:
		push_warning("JSON parse error in %s" % path)
		return result
	return parsed
