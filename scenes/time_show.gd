extends Label

## object wich holds the infos
@export var player_object: CharacterBody3D

func _physics_process(delta: float) -> void:
    if player_object and player_object.get("time_used"):
        text = str(int(player_object.get("time_used")))
