@tool
extends Node3D

var straight = preload("res://scenes/skate_straight.tscn")
# corner pointing left
var corner = preload("res://scenes/skate_corner.tscn")

var tiles = 100

func next_tile():
	var r = randf()
	if r < 0.7:
		return straight.instantiate()
	var next = corner.instantiate()
	if r < 0.85:
		return next
	#next.transform.rotation_degrees.z = 90
	return next

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seed(12)
	for tile_no in range(tiles):
		var tile = next_tile()
		tile.position = Vector3(tile_no * 10, 0, 0)
		add_child(tile)
