extends TextureButton

@export var scene: String = "res://scenes/main_menu.tscn"
@export var delay: float = 1.0
@export var conf_dialog: ConfirmationDialog = null

func quit():
    get_tree().quit()

func _notification(what):
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        conf_dialog.show()

func delayTimer(seconds: float):
    return get_tree().create_timer(seconds).timeout

func _on_button_pressed():
    await delayTimer(delay)  # Wait for 2 seconds
    
    # Replace with the path to your target scene
    print("Switching to scene:", scene)
    get_tree().change_scene_to_file(scene)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    get_tree().set_auto_accept_quit(false)
    self.grab_focus()
