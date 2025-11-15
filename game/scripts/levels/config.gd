extends Node
# GLOBAL NAME: Levels
## Grabs and parses the level data based on the root config json, along with
##  child jsons

var config: Dictionary = {}
var CONFIG_PATH := "res://game/levels/config.json"

func _ready():
	print("Config: ", get_config())
	
func get_config() -> Dictionary:
	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	var raw := ""
	if file:
		raw = file.get_as_text() # raw x3
		file.close()
	else:
		print("Failed to load root config file: ", CONFIG_PATH)
	config = JSON.parse_string(raw)
	return config

func get_act(act_id: String) -> Dictionary:
	var act_info = config.get(act_id)
	var path = "%s/%s" % [act_info.get("path"), act_info.get("config")]
	
	var raw = ""
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		raw = file.get_as_text() # raw x3?
		file.close()
	else:
		print("Failed to load act file: ", path)
	var act = JSON.parse_string(raw)
	act["path"] = act_info.get("path") # top 10 ways to break the code
	
	return act

func get_level(act: Dictionary, level_id: String) -> Dictionary:
	var level_info = act["levels"].get(level_id)
	var path = "%s/%s" % [act.get("path"), level_info.get("file")]
	
	var raw = ""
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		raw = file.get_as_text() # raw x3??
		file.close()
	else:
		print("Failed to load level file: ", path)
	var level = JSON.parse_string(raw)
	return level
