extends Control
var screen_manager: Node = null
@onready var current_creature: TextureRect = $Panel/CurrentCreature
@onready var sfx_slider: HSlider = $Panel/SFXSliderLabel/SFXSlider
@onready var music_slider: HSlider = $Panel/MusicSliderLabel/MusicSlider

func _ready() -> void:
	SignalBus.overlay_activated.connect(_on_overlay_activated)

func _on_back_to_game_button_pressed() -> void:
	screen_manager.show_overlay("HudOverlay")
	screen_manager.hide_overlay("PauseOverlay")
	get_tree().paused = false
	
func _on_overlay_activated(overlay: Control) -> void:
	if overlay == self:
		print("Activated Pause")
		current_creature.texture = CreatureUiManager.current_creature_data.texture
		music_slider.value = AudioManager.music_slider_value
		sfx_slider.value = AudioManager.sfx_slider_value
	


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume_by_slider(value)
	

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume_by_slider(value)
