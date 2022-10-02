extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	yield(get_tree().create_timer(rand_range(0,2)), "timeout")
	$AnimationPlayer.playback_speed = rand_range(0.8,1.2)
	$AnimationPlayer.play("Glow")
