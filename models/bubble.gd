extends CharacterBody3D

@export_group("General Controls")
@export_range(0.1, 1, 0.1) var sensitivity: float = 0.5  ## Overall sensitivity that will affect most movements
@export var movement_speed: int = 10  ## Controls how much the character moves per frame where the move input is active

@export_group("Camera Handling (Mouse only)")
@export var camera_deadzone: int = 100  ## Minimum distance the mouse has to be moved before the camera will react
@export var rotation_divisor: int = 100  ## Controls how strongly the camera will respond to mouse movement

@export_group("Camera Handling (Joystick only)")
@export var rotation_delta: int = 6  ## Controls how strongly the camera will respond to stick movement


func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(_delta):
    if !Input.is_anything_pressed():
        velocity = Vector3.ZERO
        return

    if Input.is_action_pressed("look_left"):
        rotation_degrees.y += rotation_delta * sensitivity * Input.get_action_strength("look_left")
    elif Input.is_action_pressed("look_right"):
        rotation_degrees.y -= rotation_delta * sensitivity * Input.get_action_strength("look_right")

    var movement_delta = movement_speed * sensitivity
    var local_movement = to_local(Vector3.ZERO)
    if Input.is_action_pressed("move_right"):
        movement_delta = movement_delta * Input.get_action_strength("move_right")
        local_movement += Vector3.LEFT * movement_delta
    if Input.is_action_pressed("move_left"):
        movement_delta = movement_delta * Input.get_action_strength("move_left")
        local_movement += Vector3.RIGHT * movement_delta
    if Input.is_action_pressed("move_forwards"):
        movement_delta = movement_delta * Input.get_action_strength("move_forwards")
        local_movement += Vector3.BACK * movement_delta
    if Input.is_action_pressed("move_backwards"):
        movement_delta = movement_delta * Input.get_action_strength("move_backwards")
        local_movement += Vector3.FORWARD * movement_delta
    velocity = to_global(local_movement)
    velocity.y = 0
    move_and_slide()


func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var x_velocity = snapped(event.screen_velocity.x, 1)
        if abs(x_velocity) > camera_deadzone:
            rotation_degrees.y += (-x_velocity / rotation_divisor) * sensitivity
