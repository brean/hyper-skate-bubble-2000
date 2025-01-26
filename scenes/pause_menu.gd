extends Control

signal continue_pressed


func _on_paused():
    $ContinueButton.grab_focus()


func _emit_continue_signal():
    continue_pressed.emit()


func _on_quit():
    get_tree().quit()
