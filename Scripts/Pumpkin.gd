extends Node2D

export var dialogPath: NodePath
var main: Node2D = get_parent()

func interaction(player: Player) -> void:
	var dialog_player = get_node_or_null(dialogPath)
		
	if dialog_player:
		dialog_player.start(player)
