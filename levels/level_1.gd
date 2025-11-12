extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	$StartTimer.start()




func _on_spawn_timer_timeout() -> void:
	# Spawn mob
	var mob = mob_scene.instantiate()
	
	var mob_spawn_loc = $MobPath/MobSpawnLocation
	mob_spawn_loc.progress_ratio = randf()
	
	mob.position = mob_spawn_loc.position
	
	#var direction = mob_spawn_loc.rotation + PI / 2
	#direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction	
	
	var vel = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = vel
	
	add_child(mob)


func _on_start_timer_timeout() -> void:
	$SpawnTimer.start()
