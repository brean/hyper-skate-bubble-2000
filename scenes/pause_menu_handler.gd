extends Node3D

signal on_paused

func _on_continue():
    get_child(0).visible = false
    get_tree().paused = false


func _process(delta: float) -> void:
    if Input.is_action_just_released("pause"):
        if !get_tree().paused:
            get_child(0).visible = true
            get_tree().paused = true
            on_paused.emit()
        else:
            get_child(0).visible = false
            get_tree().paused = false
