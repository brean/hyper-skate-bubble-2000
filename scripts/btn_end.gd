extends Node

@export var conf_dialog: ConfirmationDialog = null

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	
func quit():
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		conf_dialog.show()
