extends Node

@export var config: Dictionary = {}
var CONFIG_PATH = "res://game/levels/config.json"

func _ready():
	get_config()
	
func get_config() -> Dictionary:
	var file = FileAccess.open(CONFIG_PATH, FileAccess.READ)
	var raw = file.get_as_text() # raw x3
	file.close()
	
	config = JSON.parse_string(raw)
	return config

func get_act(act_id: String) -> Dictionary:
	var act_info = config.get(act_id)
	var path = "%s/%s" % [act_info.get("path"), act_info.get("config")]
	
	var file = FileAccess.open(path, FileAccess.READ)
	var raw = file.get_as_text() # raw x3?
	file.close()
	
	var act = JSON.parse_string(raw)
	act["path"] = act_info.get("path") # top 10 ways to break the code
	
	return act

func get_level(act: Dictionary, level_id: String) -> Dictionary:
	var level_info = act["levels"].get(level_id)
	var path = "%s/%s" % [act.get("path"), level_info.get("file")]
	
	var file = FileAccess.open(path, FileAccess.READ)
	var raw = file.get_as_text() # raw x3??
	file.close()
	
	var level = JSON.parse_string(raw)
	return level
