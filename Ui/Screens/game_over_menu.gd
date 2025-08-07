extends Control
var screen_manager: Node = null
	
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
func _on_button_pressed() -> void:
	screen_manager.swap_to("MainMenu")

func _on_screen_swapped(screen: Node):
	if screen == self:
		pass
