extends Area3D
@export var scene: String = "res://scenes/main_menu.tscn"
@export var delay: float = 1.0

func delayTimer(seconds: float):
    return get_tree().create_timer(seconds).timeout

func _ready():
    # Connect the signal to the function
    self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if body.is_in_group("player"):
        body.dispatch_player_dead("spikes")
        await delayTimer(delay)
        get_tree().change_scene_to_file(scene)
