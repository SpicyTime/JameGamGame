extends Control

func hide_screen() -> void:
	$CanvasLayer.visible = false
	
	#print("Hiding Menu")
	
func show_screen() -> void:
	$CanvasLayer.visible = true
	#print("Shiowing Menu")
func _on_play_button_pressed() -> void:
	ScreenManager.swap_to("PreRoundMenu")


func _on_settings_button_pressed() -> void:
	ScreenManager.swap_to("SettingsMenu")
