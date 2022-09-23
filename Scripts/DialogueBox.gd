extends CanvasLayer
 
export(String, FILE, "*.json") var dialogPath
export(float) var textSpeed = 0.05
 
var dialog
 
var phraseNum = 0
var finished = false
 
func _ready():
	$DialogBox.visible = false

func start():
	$DialogBox/Timer.wait_time = textSpeed
	
	$DialogBox.visible = true
	
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
 
func _process(_delta):
	$DialogBox/Indicator.visible = finished
	if Input.is_action_just_pressed("interact"):
		if finished:
			nextPhrase()
		else:
			$DialogBox/Text.visible_characters = len($DialogBox/Text.text)
 
func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), "File path does not exist")
	
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
 
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
		print("poop finished")
		return
	
	finished = false
	
	$DialogBox/Name.bbcode_text = dialog[phraseNum]["Name"]
	$DialogBox/Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$DialogBox/Text.visible_characters = 0
	
	while $DialogBox/Text.visible_characters < len($DialogBox/Text.text):
		$DialogBox/Text.visible_characters += 1
		
		$DialogBox/Timer.start()
		yield($DialogBox/Timer, "timeout")
	
	finished = true
	phraseNum += 1
	$DialogBox/Indicator/AnimationPlayer.play("Arrow STS")
	return
















