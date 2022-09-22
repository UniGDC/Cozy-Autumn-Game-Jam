extends ColorRect

export var dialoguePath = "res://dialogue.json"
export(float) var textSpeed = 0.05

var dialogue

var phraseNum = 0
var finished = false

func _ready():
	$Timer.wait_time = textSpeed
	dialogue = getDialogue()
	assert(dialogue, "Dialog not found")

func _process(_delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("interact"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)

func getDialogue() -> Array:
	var f = File.new()
	assert(f.file_exists(dialoguePath), "File path does not exist")
	
	f.open(dialoguePath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
func nextPhrase() -> void:
	if phraseNum >= len(dialogue):
		queue_free()
		return
	
	finished = false
	
	$Name.bbcode_text = dialogue[phraseNum]["Name"]
	$Text.bbcode_text = dialogue[phraseNum]["Name"]
	
	$Text.visible_characters = 0
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	phraseNum += 1
	return
	

















