extends Node
class_name Wave

signal mob_spawned(mob_instance)


## The total n mobs to spawn along this path
var total_mobs: int
## The type of mob this specification is for
var mob_type: PackedScene
## The mob's path for this level. E.g. PathA, PathB, etc
var mob_path: PathFollow2D
## An array of `wait_time`s before spawning the next mob.
#@export var spawn_pattern: Array[float]
## The interval between spawns for this wave.
#var interval: float

# Helpful explanation of scene vs script
# https://www.reddit.com/r/godot/comments/f7uswi/comment/fig057f/

# Here, we link the `mob_type` strings to their scenes.
# We prefer scenes since each scene can have a custom script attached, cleaning
# up the future code. aka the mob_type is declaritive
var MOB_TYPES = {
	"generic": preload("res://game/scenes/entities/abstract/mob.tscn")
}

var MIN_DELAY = 0.000001
var MAX_DELAY = 10000000000 # arbitrary, no sys.maxsize :(
var wave_id = ""

## Inspired by https://www.reddit.com/r/godot/comments/13pm5o5/comment/kxvpbex/
func with_params(total_mobs_: int, type_: String, path: PathFollow2D, interval: float, delay: float, wave_id_: String):
	interval = clamp(interval, MIN_DELAY, MAX_DELAY)
	delay = clamp(delay, MIN_DELAY, MAX_DELAY)
	#print("Received params: total_mobs:%s, type_:%s, path:%s, interval:%s delay:%s" % [total_mobs, type_, path, interval, delay])
	self.total_mobs = total_mobs_
	self.mob_type = MOB_TYPES[type_]
	self.mob_path = path
	self.wave_id = wave_id_
	$SpawnTimer.wait_time = interval
	$StartTimer.wait_time = delay
	return self

var spawn_pattern_idx = 0
var mobs_spawned = 0


func _on_spawn_timer_timeout() -> void:
	# Create mob and assign imports
	var mob = mob_type.instantiate().with_params(mob_path)
	# Set to start of path.
	mob_path.progress_ratio = 0
	mob.position = mob_path.position
	# Set delay for next spawn
	# Add to tree
	mobs_spawned += 1
	add_child(mob)
	mob_spawned.emit(mob)
#	# Handle last mob
	if mobs_spawned >= total_mobs:
		stop()

func _on_start_timer_timeout() -> void:
	$SpawnTimer.start()
	print("[%s] Spawning %d generics" % [wave_id, total_mobs])
	
func start():
	$StartTimer.start()

func stop():
	$StartTimer.stop()  # Unlikely to be running unless just started.
	$SpawnTimer.stop()
