extends Node2D

func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,  SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1024,600),1)
	
func _on_TextureButton_pressed():
	get_tree().change_scene("res://World.tscn")
