extends TextureButton


func _ready() -> void:
	disable()

func disable():
	self.disabled = true
	self.focus_mode=Control.FOCUS_NONE

func enable():
	self.disabled = false
	self.focus_mode=Control.FOCUS_ALL
