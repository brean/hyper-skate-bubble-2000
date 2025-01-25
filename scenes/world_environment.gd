extends WorldEnvironment

@export var knifebot_closest: float = 0.5  ## Minimum distance at which the desaturation effect will be strongest
@export var knifebot_furthest: float = 2  ## Maximum distance at which the desaturation effect will not occur

@export var min_saturation: float = 0
@export var max_saturation: float = 1.5

func _on_knifebot_distance_changed(new_distance: float):
    if new_distance < knifebot_closest:
        environment.adjustment_saturation = min_saturation
        return

    if new_distance > knifebot_furthest:
        environment.adjustment_saturation = max_saturation
        return

    environment.adjustment_saturation = min_saturation + (new_distance / (knifebot_furthest - knifebot_closest))
