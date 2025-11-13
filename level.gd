extends Node

@export var mob_type: PackedScene
@export var spawn_pattern: Array[float]  # of length total-1, delays before next spawn.
@export var total_mobs: int
@export var _reset_at_end: bool = false

#var score
var spawn_pattern_idx = 0
var mobs_spawned = 0
var DEFAULT_SPAWN_TIMER_WT
var mobs: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#score = 0
	$StartTimer.start()
	DEFAULT_SPAWN_TIMER_WT = $SpawnTimer.wait_time

func reset():
	$StartTimer.stop()
	$SpawnTimer.stop()
	$SpawnTimer.wait_time = DEFAULT_SPAWN_TIMER_WT
	spawn_pattern_idx = 0
	mobs_spawned = 0
	for mob in mobs:
		mob.queue_free()
	mobs.clear()
	$StartTimer.start()

func _on_spawn_timer_timeout() -> void:
	# Spawn mob
	var mob_spawn_loc = $MobPath/MobFollowPath
	
	# Create mob and assign imports
	var mob = mob_type.instantiate()
	
	mob.mob_path = mob_spawn_loc
	# Set to start of path.
	mob_spawn_loc.progress_ratio = 0
	mob.position = mob_spawn_loc.position
	# Set delay for next spawn
	$SpawnTimer.wait_time = spawn_pattern[spawn_pattern_idx]
	spawn_pattern_idx += 1
	mobs_spawned += 1
	if (spawn_pattern_idx >= spawn_pattern.size()):
		spawn_pattern_idx = 0
	var last_mob = false
	if mobs_spawned >= total_mobs:
		$SpawnTimer.stop()
		last_mob = true
	# Add to tree
	add_child(mob)
	mobs.append(mob)
	
	if _reset_at_end and last_mob:
		reset()


func _on_start_timer_timeout() -> void:
	$SpawnTimer.start()
