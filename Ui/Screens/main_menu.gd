extends Control
var screen_manager: Node = null
	
func _on_play_button_pressed() -> void:
	screen_manager.swap_to("PreRoundMenu")


func _on_settings_button_pressed() -> void:
	screen_manager.show_overlay("SettingsOverlay")
