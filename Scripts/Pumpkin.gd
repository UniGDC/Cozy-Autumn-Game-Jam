extends Node2D

export var hudPath: NodePath

onready var HUD_Node: Control = get_node(hudPath)

func interaction(player: Player) -> void:
	pass
