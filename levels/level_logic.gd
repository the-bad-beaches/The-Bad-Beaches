extends Node
@export var mob_spawners: Array[MobSpawner]
## Overrides the StartTimer wait_time for this level's logic.
@export var overrideStartDelay: int = -1
## (Debug) Resets the level to starting conditions as soon as the last mob spawns.
#@export var _reset_at_end: bool = false

## Mobs for each index of MobSpawner
var mobs_on_tracks: Array[Array] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Attach spawners
	for mob_spawner in mob_spawners:
		print("Installing mob_spawner...", mob_spawner)
		var mobs_for_spawner = []
		var callback = func(mob):
			mobs_for_spawner.append(mob)
		mob_spawner.mob_spawned.connect(callback)
		mobs_on_tracks.append(mobs_for_spawner)
	
	if overrideStartDelay != -1:
		$StartTimer.wait_time = overrideStartDelay
	$StartTimer.start()

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
