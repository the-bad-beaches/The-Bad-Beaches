extends Area2D
signal hit
signal fire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	$IFrameTimer.start()


func _on_i_frame_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
