extends Node

export(Array, Array, String) var level_dialogue
export(Array, PackedScene) var level_array
export(PackedScene) var win_screen

var current_level: int = 0

onready var current_music: AudioStreamPlayer = $MusicHappy

var music_playing: bool = false


func _ready() -> void:
	start_music()


func start_music() -> void:
	music_playing = true
	current_music.play()


func stop_music() -> void:
	music_playing = true
	current_music.stop()


func change_level() -> void:
	$AnimationPlayer.play("fade out")
	yield(get_tree().create_timer(0.6), "timeout")
	
	
	if current_level < level_array.size() - 1:
		current_level += 1
		get_tree().change_scene_to(level_array[current_level])
	else:
		yield(get_tree().create_timer(0.6), "timeout")
		
		win()
		
	if current_level == 2:
		stop_music()
		current_music = $MusicQuiet
		start_music()
	
	$AnimationPlayer.play("fade in")
		
		

func win() -> void:
	$KillEffect.play()
	stop_music()
	get_tree().change_scene_to(win_screen)
	yield(get_tree().create_timer(0.6), "timeout")
	$WinMusic.play()
	$KillEffect.stop()
