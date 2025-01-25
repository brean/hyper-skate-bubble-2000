extends Control

@export var main_scene_path = "res://scenes/main.tscn"
@export var credits_scene_path = "res://scenes/credits.tscn"

@export var button_sound: AudioStreamPlayer
@export var button_sound_clip = 1


func play_button_sound():
    button_sound.play()
    await get_tree().create_timer(button_sound_clip).timeout


func _on_game_quit():
    await play_button_sound()
    get_tree().quit()


func _on_show_credits():
    await play_button_sound()
    get_tree().change_scene_to_file(credits_scene_path)


func _on_start_game():
    await play_button_sound()
    get_tree().change_scene_to_file(main_scene_path)
