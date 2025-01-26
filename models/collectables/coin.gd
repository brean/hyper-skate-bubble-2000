extends Area3D

@export_range(1, 20, 1) var points_worth: int = 1
@export_range(0.1, 2, 0.1) var time_to_delete: float = 0.3

var target_object: Node3D

func _collected(collecting_object: Node3D):
    # get unvisible by physics
    set_collision_layer_value(1, false)
    set_collision_mask_value(1, false)
    
    target_object = collecting_object
    
    # play audio
    $audio_collected.play()
    
    # get bigger
    $Node/coin2/coin.scale = Vector3(2, 2, 2)
    # wait
    await get_tree().create_timer(time_to_delete).timeout
    queue_free()


func _physics_process(_delta: float) -> void:
    # if target is set, follow whis object
    if target_object:
        global_position += 0.1 * (target_object.global_position - global_position)
