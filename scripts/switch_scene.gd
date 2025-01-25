extends Node

@export var scene: String = "res://scenes/main_menu.tscn"

func _on_button_pressed():
	# Replace with the path to your target scene
	print("Switching to scene:", scene)
	get_tree().change_scene_to_file(scene)
