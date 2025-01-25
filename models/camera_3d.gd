extends Camera3D

## the object the camera-position follows
@export var camera_controler: Node3D
## the object to look at
@export var camera_target: Node3D
## smoothness, 99 is max.
@export_range(0, 99, 1) var smoothness: int = 90

# position in global space
var transform_before: Transform3D

func _ready() -> void:
	transform_before = global_transform
	
	# sich selbst in die Hauptszene verlegen
	get_parent().remove_child.call_deferred(self)
	get_parent().get_parent().get_parent().add_child.call_deferred(self)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Wenn Kamera-Controler nicht mehr existiert, sich selbst auch löschen
	if not is_instance_valid(camera_controler):
		queue_free()
		return
	
	if not global_transform.basis.is_conformal():
		transform_before = camera_controler.global_transform
		global_transform = camera_controler.global_transform
	
	var distance_to_camera_controler = camera_controler.global_position.distance_to(global_position)

	global_transform = transform_before.interpolate_with(camera_controler.global_transform, (100-smoothness) * distance_to_camera_controler * 2 * delta)
	transform_before = global_transform
