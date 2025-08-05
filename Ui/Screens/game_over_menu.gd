extends Control

func show_screen() -> void:
	$CanvasLayer.visible = true
	
func hide_screen() -> void:
	$CanvasLayer.visible = false
	
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
func _on_button_pressed() -> void:
	ScreenManager.swap_to("MainMenu")

func _on_screen_swapped(screen: Node):
	if screen == self:
		pass
