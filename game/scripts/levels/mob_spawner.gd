extends Node
class_name MobSpawner

signal mob_spawned(mob_instance)

## The type of mob this specification is for
@export var mob_type: PackedScene
## The mob's path for this level. E.g. PathA, PathB, etc
@export var mob_path: PathFollow2D
## The total n mobs to spawn along this path
@export var total_mobs: int
## An array of `wait_time`s before spawning the next mob.
@export var spawn_pattern: Array[float]


var spawn_pattern_idx = 0
var mobs_spawned = 0
@onready var DEFAULT_SPAWN_TIMER_WT = $SpawnTimer.wait_time


func _on_spawn_timer_timeout() -> void:
	# Create mob and assign imports
	var mob = mob_type.instantiate()
	mob.mob_path = mob_path
	# Set to start of path.
	mob_path.progress_ratio = 0
	mob.position = mob_path.position
	# Set delay for next spawn
	if spawn_pattern:
		print("Assigning dynamic wait time to timer: ", $SpawnTimer)
		if spawn_pattern[spawn_pattern_idx] <= 0:
			$SpawnTimer.wait_time = DEFAULT_SPAWN_TIMER_WT
		else:
			$SpawnTimer.wait_time = spawn_pattern[spawn_pattern_idx]
		spawn_pattern_idx += 1
		if (spawn_pattern_idx >= spawn_pattern.size()):
			spawn_pattern_idx = 0
	# Add to tree
	mobs_spawned += 1
	add_child(mob)
	mob_spawned.emit(mob)
#	# Handle last mob
	if mobs_spawned >= total_mobs:
		stop()

func stop():
	$SpawnTimer.stop()
