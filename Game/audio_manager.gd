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
