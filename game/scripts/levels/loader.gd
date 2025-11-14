extends Node


func _ready() -> void:
	# assume we just want level 1 for now
	load_level("act_1", "level_1")
	
func load_level(act_id: String, level_id: String):
	var level = Levels.get_level(Levels.get_act(act_id), level_id)
	var path = level.get("path", null)
	
	# not sure if path2d is the best option, todo: read into this
	if path:
		var path2d := Path2D.new()
		var curve := Curve2D.new()
		
		for point in path:
			curve.add_point(Vector2(point[0], point[1]))
		
		path2d.curve = curve
		path2d.name = "hi"
		add_child(path2d)
		
	print("Loaded level [%s] ('%s')!" % [level_id, level.get("name")])
