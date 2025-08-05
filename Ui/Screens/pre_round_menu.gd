extends Control
@onready var texture_rect: TextureRect = $CanvasLayer/Control/Panel/TextureRect


func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
func hide_screen() -> void:
	$CanvasLayer.visible = false
	
func show_screen() -> void:
	$CanvasLayer.visible = true


func _on_button_pressed() -> void:
	ScreenManager.swap_to("Game")
	
func _on_screen_swapped(screen) -> void:
	if screen == self:
		texture_rect.texture = CreatureUiManager.pick_creature().texture
