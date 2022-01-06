extends Area2D

var MOVE_SPEED=600



func _on_Spring_body_entered(body):
	if body.name == "Player" :
		body.velocity.y =-50000
		body.move_and_slide (body.velocity)
		$AnimationPlayer.play("launch")
