extends Node
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
var sfx_slider_value: float = 0.5
var music_slider_value: float = 0.5
func _ready() -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(sfx_slider_value))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(music_slider_value))
	
func set_sfx_volume_by_slider(slider_value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(slider_value))
	sfx_slider_value = slider_value
	
func set_music_volume_by_slider(slider_value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(slider_value))
	music_slider_value = slider_value
func fade_out_music() -> void:
	pass
	
func fade_in_music() -> void:
	pass
func play_whoosh() -> void:
	var new_audio = AudioStreamPlayer.new()
	new_audio.bus = "SFX"
	new_audio.stream = preload("res://Ui/UiItemWhoosh.wav")
	new_audio.pitch_scale = 0.1  # Half speed, lower pitch
	add_child(new_audio)
	new_audio.play()
	
	var duration = new_audio.stream.get_length()  # length in seconds
	await get_tree().create_timer(duration).timeout
	new_audio.queue_free()
	
