extends CharacterBody3D

@export_group("General Controls")
@export_range(0.1, 1, 0.1) var sensitivity: float = 0.5  ## Overall sensitivity that will affect most movements
@export_range(1, 100, 0.1) var movement_speed: float = 20  ## Controls how much the character moves per frame where the move input is active
@export_range(0, 100, 0.1) var jump_force: float = 15  ## Controls how much upwards force will be applied for a jump
@export var jump_mass: float = 4.0  ## Controls how quickly the character will fall back down after jumping

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
signal player_won(data)  ## player won!

# how many coins where collected
var coins_collected_amount: int = 0
signal coin_collected(total_amount: int)
# time elapsed in seconds
var time_used: float = 0



func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    player_dead.connect(_on_player_dead)
    player_won.connect(_on_player_won)


func _process(_delta: float) -> void:
    if global_position.y <= -10:
        get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func dispatch_player_dead(data):
    emit_signal("player_dead", data)
    
func dispatch_player_moved(data):
    emit_signal("player_moved", data)

func dispatch_player_won(data):
    emit_signal("player_won", data)    

func delayTimer(seconds: float):
    return get_tree().create_timer(seconds).timeout

func _on_player_won(data):
    var cam = $"../../WinCam"
    cam.current = true
    $"../../WinAnimationPlayer".play("new_animation")
    await delayTimer(4)
    get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_player_dead(data):
    if dead_in_space:
        # we are already dead - return to not create a new timer
        return
    dead_in_space = true
    $Mesh.hide()
    $death_particles.emitting = true
    await delayTimer(dead_delay)
    get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _physics_process(delta):
    time_used += delta

    if dead_in_space:
        # we died in place e.g. by touching spikes
        # so we, do NOT apply anything and just return
        return

    if Input.is_anything_pressed():
        if not first_input:
            first_input = true
            self.dispatch_player_moved("first")

 # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta * jump_mass

    # Handle jump.
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_force
    
    # handle movement
    var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
    
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * movement_speed
        velocity.z = direction.z * movement_speed
    else:
        velocity.x = move_toward(velocity.x, 0, movement_speed)
        velocity.z = move_toward(velocity.z, 0, movement_speed)
    
    # camera movement
    var camera_movement: float
    camera_movement = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")
    rotation_degrees.y += camera_movement * rotation_delta * sensitivity
    
    # rotation of the disco-sphere
    if input_dir or camera_movement:
        $Mesh.global_rotate(transform.basis.x.normalized(), input_dir.y * 0.1)
        $Mesh.global_rotate(transform.basis.y.normalized(), camera_movement * 0.1)
        $Mesh.global_rotate(transform.basis.z.normalized(), -input_dir.x * 0.1)
    # += Vector3(input_dir.y, camera_movement, -input_dir.x).normalized() * 0.1

    move_and_slide()
    

func _input(event: InputEvent) -> void:
    if dead_in_space:
        return
    if event is InputEventMouseMotion:
        var x_velocity = snapped(event.screen_velocity.x, 1)
        if abs(x_velocity) > camera_deadzone:
            rotation_degrees.y += (-x_velocity / rotation_divisor) * sensitivity


func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.is_in_group("coin"):
        area.queue_free()
        coins_collected_amount += 1
        coin_collected.emit(coins_collected_amount)
