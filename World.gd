extends Node2D


func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED,  SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1024,600),1)
