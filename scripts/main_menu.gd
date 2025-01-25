extends Control


# Function to close the game
func close_game():
    #get_cancel_button().pressed.connect(_on_canceled)
    pass
func _on_canceled():
    print("Closing the game...")
    get_tree().quit()
