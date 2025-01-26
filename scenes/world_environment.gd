extends WorldEnvironment

@export var knifebot_closest: float = 0.5  ## Minimum distance at which the desaturation effect will be strongest
@export var knifebot_furthest: float = 2  ## Maximum distance at which the desaturation effect will not occur

@export var min_saturation: float = 0
@export var max_saturation: float = 1.5

var dead_in_space: bool = false

func _ready() -> void:
    var player = $"../Bubble"
    if player.has_signal("player_dead"):
        player.player_dead.connect(_on_player_dead)

func _on_knifebot_distance_changed(new_distance: float):
    if dead_in_space:
        return

    if new_distance < knifebot_closest:
        environment.adjustment_saturation = min_saturation
        return

    if new_distance > knifebot_furthest:
        environment.adjustment_saturation = max_saturation
        return

    environment.adjustment_saturation = min_saturation + (new_distance / (knifebot_furthest - knifebot_closest))


func _on_player_dead(data):
    # the player died, we keep her/him in space on purpose
    dead_in_space = true
    environment.adjustment_saturation = min_saturation
