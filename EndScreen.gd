extends Node

var gameOver = false
var endTime
var currentTime


func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,  SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1024,600),1)

func _on_TextureButton_pressed():
  get_tree().change_scene("res://World.tscn")

func _process(delta):
	gameOver = Globals.gameOver
	if gameOver:
		endTime = Globals.endTime
		currentTime = Globals.currentTime
		if !Globals.bestTime || currentTime < Globals.bestTime:
			Globals.bestTime = currentTime
		$TimeBlack.text = "Your Time:  %s" % [endTime]
		$TimeWhite.text = "Your Time:  %s" % [endTime]
		##display the best time in mm : ss
		var sec = fmod(Globals.bestTime,60)
		var mins = fmod(Globals.bestTime,60*60)/60
		var bestTimeDisplay = "%02d : %02d" % [mins,sec]
		$BestTimeWhite.text = "Best Time:  %s" % [bestTimeDisplay]
		$BestTimeBlack.text = "Best Time:  %s" % [bestTimeDisplay]
