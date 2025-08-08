extends Control
var screen_manager: Node = null
	
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	SignalBus.game_over.emit()

func _on_screen_swapped(screen: Node):
	if screen == self:
		pass
