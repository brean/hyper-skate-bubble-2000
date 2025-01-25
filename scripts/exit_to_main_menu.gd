extends Node


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        exit_to_main()
        

@export var scene: String = "res://scenes/main_menu.tscn"

func exit_to_main():
    # Replace with the path to your target scene
    print("Switching to scene:", scene)
    get_tree().change_scene_to_file(scene)
