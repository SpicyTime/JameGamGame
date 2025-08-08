extends Control
@onready var music_slider: HSlider = $Panel/MusicLabel/MusicSlider
@onready var sfx_slider: HSlider = $Panel/SFXSlider/SFXSlider
var screen_manager: Node = null

func _ready() -> void:
	SignalBus.overlay_activated.connect(_on_overlay_activated)

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume_by_slider(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume_by_slider(value)
	
func _on_overlay_activated(overlay_node: Control) -> void:
	if overlay_node == self:
		print(AudioManager.music_slider_value)
		music_slider.value = AudioManager.music_slider_value
		sfx_slider.value = AudioManager.sfx_slider_value
		print(music_slider.value)
		
func _on_exit_button_pressed() -> void:
	screen_manager.hide_overlay("SettingsOverlay")
