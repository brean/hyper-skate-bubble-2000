extends CharacterBody3D
# script for knifebot

## target to follow
@export var target: Node3D
## speed in meter per second
@export var speed: float = 4.0
## maximum is 100 with complete smooth
@export_range(0, 99) var smoothness: int = 50

var target_position_smooth: Vector3 = Vector3.ZERO

# direction towards goal in global space
var direction_to_target: Vector3
# direction for driving force, in global space
var move_direction: Vector3

# save for the gravity
var velocity_y: float

@onready var nav: NavigationAgent3D = $NavigationAgent3D

signal knifebot_distance_to_target(distance:float)

func _ready() -> void:
    # tell the target how far the knifebot is away
    if target.has_method("_on_knifebot_distance_changed"):
        knifebot_distance_to_target.connect(target._on_knifebot_distance_changed)
    $particles.emitting = true


func _physics_process(delta: float) -> void:
    # save current gravity-related velocity
    velocity_y = velocity.y
    

    # work with navigation mesh	
    nav.target_position = target.global_position
    
    # do smooth target position
    target_position_smooth += (100 - smoothness) * 0.01 * (nav.get_next_path_position() - target_position_smooth)
    
    direction_to_target = (target_position_smooth - global_position).normalized()
    var distance = nav.distance_to_target()
    # send info for distance to target
    knifebot_distance_to_target.emit(distance)
    if distance <= 2.3:
        target.dispatch_player_dead("knifebot")
    
    # get local driving force in global space
    move_direction = direction_to_target - (direction_to_target * transform.basis.y)
    
    # do the rotation
    look_at(target_position_smooth, transform.basis.y)
    
    velocity = move_direction.normalized() * speed + Vector3(0, velocity_y, 0)
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta
        
    # allign with ground
    if $RayCast3D.is_colliding():
        var n = $RayCast3D.get_collision_normal()
        var xform = align_with_y(global_transform, n)
        global_transform = global_transform.interpolate_with(xform, 0.2)

    move_and_slide()

func align_with_y(xform, new_y):
    xform.basis.y = new_y
    xform.basis.x = -xform.basis.z.cross(new_y)
    xform.basis = xform.basis.orthonormalized()
    return xform
