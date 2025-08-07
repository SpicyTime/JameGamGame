extends Control
var screen_manager: Node = null
@onready var current_creature: TextureRect = $Panel/CurrentCreature

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
	
	
