extends Area3D
@export var scene: String = "res://scenes/main_menu.tscn"
@export var delay: float = 1.0

func _ready():
    # Connect the signal to the function
    self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if body.is_in_group("player"):
        body.dispatch_player_dead("spikes")
