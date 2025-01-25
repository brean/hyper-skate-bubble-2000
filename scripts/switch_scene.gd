extends Node

@export var scene: String = "res://scenes/main_menu.tscn"
@export var delay: float = 1.0

func delayTimer(seconds: float):
    return get_tree().create_timer(seconds).timeout

func _on_button_pressed():
    await delayTimer(delay)  # Wait for 2 seconds
    
    # Replace with the path to your target scene
    print("Switching to scene:", scene)
    get_tree().change_scene_to_file(scene)
