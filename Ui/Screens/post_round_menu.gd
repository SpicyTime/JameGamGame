extends Control
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
func hide_screen() -> void:
	$CanvasLayer.visible = false
	
func show_screen() -> void:
	$CanvasLayer.visible = true

func _on_screen_swapped(screen) -> void:
	if screen == self:
		pass
