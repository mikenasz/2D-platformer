extends Camera2D

onready var player = get_node("/root/World/Player")

func _process (delta):
	
	position.y = player.position.y-100
	position.x = player.position.x-100
