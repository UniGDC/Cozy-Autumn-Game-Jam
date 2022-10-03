extends Node2D

export var dialogPath: NodePath
var main: Node2D = get_parent()


func _ready() -> void:
	$CanvasLayer.visible = true
	

func _process(delta: float) -> void:
	if $InteractZone.get_overlapping_areas().size() > 0:
		$Light2D.enabled = true
		$CtrlKey.visible = true
	else:
		$Light2D.enabled = false
		$CtrlKey.visible = false


func interaction(player: Player) -> void:
	var dialog_player = get_node_or_null(dialogPath)
		
	if dialog_player:
		dialog_player.start(player)
