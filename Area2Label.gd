extends Label

var area2Prompt = false

func _ready():
	pass


func _process(delta):
	area2Prompt = Globals.area2Prompt
	if area2Prompt:
		$".".show()
	else:
		$".".hide()
