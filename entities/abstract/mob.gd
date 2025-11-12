extends RigidBody2D


func _ready() -> void:
	# Choose a random sprite and play it
	$AnimatedSprite2D.animation = Array(
		$AnimatedSprite2D.sprite_frames.get_animation_names()
	).pick_random()
	$AnimatedSprite2D.play()


# Free node when off screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
