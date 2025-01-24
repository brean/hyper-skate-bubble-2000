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

func _physics_process(delta: float) -> void:
	velocity_y = velocity.y

	move_direction = Vector3(0, 0, -1)

	velocity = move_direction.normalized() * speed * transform.basis.z + Vector3(0, velocity_y, 0)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
