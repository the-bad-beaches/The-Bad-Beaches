extends Area2D
signal hit


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	$IFrameTimer.start()


func _on_i_frame_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
