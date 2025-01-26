extends Node3D


func _process(delta: float) -> void:
    if Input.is_action_just_released("pause"):
        get_tree().paused = !get_tree().paused
