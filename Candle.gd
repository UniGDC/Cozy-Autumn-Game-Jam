extends Sprite



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(rand_range(0,1)), "timeout")
	$AnimationPlayer.playback_speed = rand_range(0.8,1.2)
	$AnimationPlayer.play("Glow")
