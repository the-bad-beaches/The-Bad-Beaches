extends Node
# Game startup script

## Overrides the StartTimer wait_time for this level's logic.
#@export var override_start_delay: int = -1

var GAME_STRUCTURE: Dictionary[String, Array] = {
	"act_1" : [
		"level_1",
		"level_2"
	]
}

## The Wave scene used to control independent waves.
@onready var WaveScene = preload("res://game/scenes/levels/wave.tscn")

## Spawners for mobs
var mob_waves: Array[Node2D]
## Mobs for each index of mob_waves
var mobs_on_tracks: Array[Array] = []

# The below only runs once on startup as the Main Scene.
func _ready() -> void:
	# assume we just want level 1 for now
	Levels.get_config()
	load_level("act_1", "level_1")
	$StartTimer.start()

func load_level(act_id: String, level_id: String):
	print("Loading level: %s %s" % [act_id, level_id])
	var level = Levels.get_level(Levels.get_act(act_id), level_id)
	var path_data = level.get("paths", null)
	#print("Path Data: ", path_data)
	
	# not sure if path2d is the best option, todo: read into this
	var path_id_to_path: Dictionary[String, PathFollow2D]
	for path_datum in path_data:
		#print("Path: ", path_datum)
		var path2d := Path2D.new()
		path2d.curve = Curve2D.new()
		path2d.name = path_datum["id"]  # yuck, name shoudln't be id
		for point in path_datum["path"]:
			#print("Point: ", point)
			path2d.curve.add_point(Vector2(point[0], point[1]))
		add_child(path2d)
		var path_follow_node = PathFollow2D.new()
		path2d.add_child(path_follow_node)
		path_id_to_path[path2d.name] = path_follow_node
		
		# Instantiate WaveScene
	for wave_data in level.get("waves", null):
		# Unpack values
		var delay = wave_data["delay"]
		for wave_datum in wave_data["mobs"]:
			var total = wave_datum["total"]
			var type_ = wave_datum["type"]
			var path_id = wave_datum["path"]
			var interval = wave_datum["interval"]
			var wave = WaveScene.instantiate().with_params(
				total, type_, path_id_to_path[path_id], interval, delay, path_id
			)
			# Init & attach buffers and callbacks
			var mobs_for_wave = []
			var callback = func(mob):
				mobs_for_wave.append(mob)
			wave.mob_spawned.connect(callback)
			mob_waves.append(wave)
			mobs_on_tracks.append(mobs_for_wave)
			add_child(wave)
			
	print("Loaded level [%s] ('%s')!" % [level_id, level.get("name")])


func reset():
	$StartTimer.stop()
	stop_spawners()
	for mobs in mobs_on_tracks:
		for mob in mobs:
			mob.queue_free()  # TY queue_free for no double frees <3
		mobs.clear()
	mobs_on_tracks.clear()
	$StartTimer.start()


func stop_spawners():
	for wave in mob_waves:
		wave.stop()

func _on_start_timer_timeout() -> void:
	for wave in mob_waves:
		print("Starting wave [%s:%d] " % [wave.mob_type, wave.get_node("SpawnTimer").wait_time])
		wave.start()
