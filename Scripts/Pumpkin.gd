extends Node2D

export var hudPath: NodePath

onready var HUD_Node: Control = get_node(hudPath)

func interaction(player: Player) -> void:
	var dialogue_player = get_node_or_null("CanvasLayer")
		
	if dialogue_player:
		dialogue_player.start()
