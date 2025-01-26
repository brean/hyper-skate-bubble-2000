extends Label

## object wich holds the infos
@export var player_object: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player_object.coin_collected.connect(coin_collected)

func coin_collected(coins_total_amount: int, points_total_amount: int):
    text = str(points_total_amount)
