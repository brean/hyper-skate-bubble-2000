extends Node

@export var renderers: Array[CanvasItem]  # Array of renderers to adjust opacity
@export var fade_out_time: float = 1.0  # Time in seconds for the fade-out effect
@export var fade_in_time: float = 0.5  # Time in seconds for the fade-out effect


# Called when the scene starts
func _ready():
    # Execute fade out at the start of the scene
    self.visible = true
    fade_out_opacity()

# Function to fade out the opacity of the given renderers
func fade_in_opacity():
    enable_renderers()
    var tween = get_tree().create_tween()
    for renderer in renderers:
        if renderer and renderer is CanvasItem:
            # Tween the "modulate:a" (opacity) property to 0 over fade_out_time
            tween.tween_property(renderer, "modulate:a", 1.0, fade_in_time)


# Callback to disable the renderers
func enable_renderers():
    print("Tween finished. Enable nodes.")
    for renderer in renderers:
        if renderer and renderer.is_inside_tree():
            var parent_node = renderer.get_parent()
            if parent_node:
                print("Enabling node:", parent_node.name)
                parent_node.set_process(true)  # Stops any ongoing processing
                parent_node.visible = true  # Hides the node
                # Optionally queue_free() to remove it entirely
                # parent_node.queue_free()

# Function to fade out the opacity of the given renderers
func fade_out_opacity():
    var tween = get_tree().create_tween()
    for renderer in renderers:
        if renderer and renderer is CanvasItem:
            # Tween the "modulate:a" (opacity) property to 0 over fade_out_time
            tween.tween_property(renderer, "modulate:a", 0.0, fade_out_time)
    # Connect a callback to the tween to disable the renderers after fading
    tween.finished.connect(disable_renderers)

# Callback to disable the renderers
func disable_renderers():
    print("Tween finished. Disabling nodes.")
    for renderer in renderers:
        if renderer and renderer.is_inside_tree():
            var parent_node = renderer.get_parent()
            if parent_node:
                print("Disabling node:", parent_node.name)
                parent_node.set_process(false)  # Stops any ongoing processing
                parent_node.visible = false  # Hides the node
                # Optionally queue_free() to remove it entirely
                # parent_node.queue_free()
