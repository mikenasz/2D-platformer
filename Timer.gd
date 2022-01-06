extends Label

var timer=0

func _process(delta):
	
	timer+= delta
	var sec= fmod(timer,60)
	var mins= fmod(timer,60*60)/60
	var elapsed = "%02d : %02d" % [mins,sec]
	text= elapsed
	Globals.endTime = elapsed
	Globals.currentTime = timer

