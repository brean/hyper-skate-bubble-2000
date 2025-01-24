extends Node

@export var music_player: AudioStreamPlayer = null
@export var fade_out_time: float = 1.0  # Time in seconds for the fade-out effect


# Function to fade out the music
func fade_out_music():
	var tween = get_tree().create_tween()
	# Ensure the music player is playing before starting the fade
	if music_player.is_playing():
		# Fade the volume out over time
		tween.tween_property(music_player, "volume_db", -80.0, fade_out_time)
