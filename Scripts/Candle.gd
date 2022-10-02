extends Sprite



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	frame = randi() % 4
	$AnimationPlayer.playback_speed = rand_range(0.8,1.2)
	yield(get_tree().create_timer(rand_range(0,2)), "timeout")
	$CPUParticles2D.emitting = true
	$AnimationPlayer.play("Glow")
