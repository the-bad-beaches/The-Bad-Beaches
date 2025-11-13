extends RigidBody2D
class_name Mob

@export var mob_path: PathFollow2D

var percent_goal = 0.0
var rate = 0.1

func _ready() -> void:
	# Choose a random sprite and play it
	$AnimatedSprite2D.animation = Array(
		$AnimatedSprite2D.sprite_frames.get_animation_names()
	).pick_random()
	$AnimatedSprite2D.play()
	if percent_goal == null:
		percent_goal = 0.0

func _process(delta) -> void:
	percent_goal = clamp(percent_goal + delta * rate, 0.0, 1.0)
	progress_path()

# Free node when off screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func progress_path() -> void:
	mob_path.progress_ratio = percent_goal
	position = mob_path.position
