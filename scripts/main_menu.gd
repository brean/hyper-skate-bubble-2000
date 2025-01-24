extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Function to close the game
func close_game():
	get_cancel_button().pressed.connect(_on_canceled)

func _on_canceled():
	print("Closing the game...")
	get_tree().quit()
