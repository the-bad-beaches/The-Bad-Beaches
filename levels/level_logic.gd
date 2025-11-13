extends Node
## The type of mob in this level. TODO: Figure out how to structure multiple types of mobs.
@export var mob_type: PackedScene
## The total number of mobs to spawn.
@export var total_mobs: int
## An array of `wait_time`s before spawning the next mob.
@export var spawn_pattern: Array[float]
## The mob's path for this level.
@export var mob_path: PathFollow2D
## Overrides the StartTimer wait_time for this level's logic.
@export var overrideStartDelay: int = -1
## (Debug) Resets the level to starting conditions as soon as the last mob spawns.
@export var _reset_at_end: bool = false


#var score
var spawn_pattern_idx = 0
var mobs_spawned = 0
var DEFAULT_SPAWN_TIMER_WT
var mobs: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#score = 0
	if overrideStartDelay != -1:
		$StartTimer.wait_time = overrideStartDelay
	$StartTimer.start()
	DEFAULT_SPAWN_TIMER_WT = $SpawnTimer.wait_time
	if mob_path == null:
		mob_path = $MobPath2D/MobFollow2D  # by default, crawl along the edges

func reset():
	$StartTimer.stop()
	$SpawnTimer.stop()
	$SpawnTimer.wait_time = DEFAULT_SPAWN_TIMER_WT
	spawn_pattern_idx = 0
	mobs_spawned = 0
	for mob in mobs:
		mob.queue_free()  # TY queue_free for no double frees <3
	mobs.clear()
	$StartTimer.start()

func _on_spawn_timer_timeout() -> void:
	# Create mob and assign imports
	var mob = mob_type.instantiate()
	mob.mob_path = mob_path
	
	# Set to start of path.
	mob_path.progress_ratio = 0
	mob.position = mob_path.position
	# Set delay for next spawn
	if not spawn_pattern:
		return
	$SpawnTimer.wait_time = spawn_pattern[spawn_pattern_idx]
	spawn_pattern_idx += 1
	mobs_spawned += 1
	if (spawn_pattern_idx >= spawn_pattern.size()):
		spawn_pattern_idx = 0
	# Add to tree
	add_child(mob)
	mobs.append(mob)
	
#	# Handle last mob
	if mobs_spawned >= total_mobs:
		$SpawnTimer.stop()
		if _reset_at_end:
			reset()


func _on_start_timer_timeout() -> void:
	$SpawnTimer.start()
