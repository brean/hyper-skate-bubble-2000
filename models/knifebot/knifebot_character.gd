extends CharacterBody3D
# script for knifebot

## target to follow
@export var target: Node3D
## speed in meter per second
@export var speed: float = 2.0
## rotate in degrees per second
@export var rotate: float = 20

# direction to drive to in global space, should always be normalized
var move_direction: Vector3

var velocity_y: float

func _ready() -> void:
	move_direction = Vector3(randf_range(-1,  1), 0, randf_range(-1, 1))

func _physics_process(delta: float) -> void:
	# save current gravity-related velocity
	velocity_y = velocity.y

	velocity = move_direction.normalized() * speed + Vector3(0, velocity_y, 0)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# allign with ground
	if $RayCast3D.is_colliding():
		var n = $RayCast3D.get_collision_normal()
		var xform = align_with_y(global_transform, n)
		global_transform = global_transform.interpolate_with(xform, 0.2)
		
	look_at(move_direction + global_position, transform.basis.y)

	move_and_slide()
	


func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
