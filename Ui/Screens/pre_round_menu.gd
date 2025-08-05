extends Control
@onready var character_texture: TextureRect = $CanvasLayer/Control/CharacterTexture
@onready var grid_container: GridContainer = $CanvasLayer/Control/AcceptableItemLabel/GridContainer
@onready var required_amount_label: Label = $CanvasLayer/Control/RequiredLabel/RequiredAmountLabel
@onready var error_tolerance_amount_label: Label = $CanvasLayer/Control/ErrorToleranceLabel/ErrorToleranceAmountLabel


func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
func hide_screen() -> void:
	$CanvasLayer.visible = false
	
func show_screen() -> void:
	$CanvasLayer.visible = true

func _on_button_pressed() -> void:
	ScreenManager.swap_to("Game")
	GameManager.fall_speed_accel += GameManager.fall_speed_accel * 0.035
	GameManager.max_spawn_delay  *= 0.9
			
func _on_screen_swapped(screen) -> void:
	if screen == self:
		var current_creature = CreatureUiManager.pick_creature()
		character_texture.texture = current_creature.texture
		for item in grid_container.get_children():
			item.queue_free()
		for item in current_creature.associated_items:
			var item_sprite: TextureRect = TextureRect.new()
			item_sprite.texture = item.texture
			grid_container.add_child(item_sprite)
			required_amount_label.text = str(current_creature.correct_items_required)
			error_tolerance_amount_label.text = str(current_creature.error_tolerance)
			
