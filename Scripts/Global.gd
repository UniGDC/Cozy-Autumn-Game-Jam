extends Node

export(Array, PackedScene) var level_array
export(PackedScene) var win_screen

var current_level: int = 0

func change_level() -> void:
#	if current_level < level_array.size() - 1:
#		current_level += 1
#		get_tree().change_scene_to(level_array[current_level])
#	else:
#		win()

	if current_level < level_array.size() - 1:
		current_level += 1
		get_tree().change_scene_to(level_array[current_level])
	else:
		current_level = 0
		get_tree().change_scene_to(level_array[current_level])
		

func win() -> void:
	get_tree().change_scene_to(win_screen)
	
