extends Label

## object wich holds the infos
@export var player_object: CharacterBody3D
var active = true

func _ready() -> void:
    player_object.player_dead.connect(_on_stop)
    player_object.player_won.connect(_on_stop)

func _on_stop(data):
    active = false

func _physics_process(delta: float) -> void:
    if active and player_object and player_object.get("time_used"):
        text = str("%.2f" % player_object.get("time_used"))
