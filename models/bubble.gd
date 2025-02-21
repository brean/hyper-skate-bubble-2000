extends CharacterBody3D

@export_group("General Controls")
@export_range(0.1, 1, 0.1) var sensitivity: float = 0.5  ## Overall sensitivity that will affect most movements
@export var movement_speed: int = 10  ## Controls how much the character moves per frame where the move input is active
@export var jump_force: int = 10  ## Controls how much upwards force will be applied for a jump
@export var jump_mass: float = 0.3  ## Controls how quickly the character will fall back down after jumping

@export_group("Camera Handling (Mouse only)")
@export var camera_deadzone: int = 100  ## Minimum distance the mouse has to be moved before the camera will react
@export var rotation_divisor: int = 100  ## Controls how strongly the camera will respond to mouse movement

@export_group("Camera Handling (Joystick only)")
@export var rotation_delta: int = 6  ## Controls how strongly the camera will respond to stick movement

@export var dead_delay: float = 1.0  ## Time we wait after the player died before we jump back to main menu

var dead_in_space: bool = false  ## the player died in space, e.g. by touching spikes
var first_input:bool = false  ## the user pressed something for the first time

signal player_dead(data)  ## signal that the player died
signal player_moved(data)  ## sinal that the player moved the first time

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    player_dead.connect(_on_player_dead)


func _process(delta: float) -> void:
    if global_position.y <= -10:
        get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func dispatch_player_dead(data):
    emit_signal("player_dead", data)
    
func dispatch_player_moved(data):
    emit_signal("player_moved", data)


func delayTimer(seconds: float):
    return get_tree().create_timer(seconds).timeout


func _on_player_dead(data):
    if dead_in_space:
        # we are already dead - return to not create a new timer
        return
    dead_in_space = true
    $Mesh.hide()
    $death_particles.emitting = true
    await delayTimer(dead_delay)
    get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _physics_process(_delta):
    var gravity = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

    if dead_in_space:
        # we died in place e.g. by touching spikes
        # so we, do NOT apply anything and just return
        return

    if !is_on_floor():
        velocity.y += gravity.y * jump_mass
        move_and_slide()
        return

    if Input.is_anything_pressed():
        if not first_input:
            first_input = true
            self.dispatch_player_moved("first")
    else:
        velocity = gravity
        move_and_slide()
        return

    if Input.is_action_pressed("jump") and is_on_floor():
        print("jump")
        velocity.y += jump_force
        move_and_slide()
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
    velocity.y = gravity.y
    $Mesh.rotation += local_movement
    move_and_slide()

func _input(event: InputEvent) -> void:
    if dead_in_space:
        return
    if event is InputEventMouseMotion:
        var x_velocity = snapped(event.screen_velocity.x, 1)
        if abs(x_velocity) > camera_deadzone:
            rotation_degrees.y += (-x_velocity / rotation_divisor) * sensitivity
