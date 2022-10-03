extends Area2D


func _process(delta: float) -> void:
	if get_overlapping_areas().size() > 0:
		$Light2D.enabled = true
		$CtrlKey.visible = true
	else:
		$Light2D.enabled = false
		$CtrlKey.visible = false


func interaction(player: Player) -> void:
	if $Sprite.frame == 1:
		Global.stop_music()
		$Sprite.frame = 0
	else:
		Global.start_music()
		$Sprite.frame = 1
