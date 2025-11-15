extends Node
# Game startup script

## Overrides the StartTimer wait_time for this level's logic.
@export var override_start_delay: int = -1

@export var GAME_STRUCTURE: Dictionary[String, Array] = {
	"act_1" : [
		"level_1",
		"level_2"
	]
}

## Spawners for mobs
var mob_spawners: Array[MobSpawner]
## Mobs for each index of MobSpawner
var mobs_on_tracks: Array[Array] = []

func _ready() -> void:
	# assume we just want level 1 for now
	Levels.get_config()
	load_level("act_1", "level_1")
	# Potentially if we wanted IT ALL (if files are small)
	#for act in GAME_STRUCTURE:
		#for level in GAME_STRUCTURE[act]:
			#load_level(act, level)
	print($StartTimer)
	if override_start_delay != -1:
		$StartTimer.wait_time = override_start_delay
	$StartTimer.start()

func load_level(act_id: String, level_id: String):
	print("Loading level: %s %s" % [act_id, level_id])
	var level = Levels.get_level(Levels.get_act(act_id), level_id)
	var path_data = level.get("paths", null)
	print("Path Data: ", path_data)
	
	var path2ds: Array[Path2D] = []
	# not sure if path2d is the best option, todo: read into this
	for path in path_data:
		print("Path: ")
		var path2d := Path2D.new()
		for point in path:
			print("Point: ", point)
			path2d.curve.add_point(Vector2(point[0], point[1]))
		add_child(path2d)
		path2ds.append(path2d)
	
	# Attach spawners
	for mob_spawner in mob_spawners:
		print("Installing mob_spawner...", mob_spawner)
		var mobs_for_spawner = []
		var callback = func(mob):
			mobs_for_spawner.append(mob)
		mob_spawner.mob_spawned.connect(callback)
		mobs_on_tracks.append(mobs_for_spawner)
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
	for mob_spawner in mob_spawners:
		mob_spawner.get_node("SpawnTimer").stop()

func _on_start_timer_timeout() -> void:
	for mob_spawner in mob_spawners:
		print("Starting mob spawner... ", mob_spawner)
		mob_spawner.get_node("SpawnTimer").start()
