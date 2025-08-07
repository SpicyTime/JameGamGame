extends Control
@onready var character_texture: TextureRect = $CharacterTexture
@onready var grid_container: GridContainer = $AcceptableItemLabel/GridContainer
@onready var required_amount_label: Label = $Panel/RequiredLabel/RequiredAmountLabel
@onready var error_tolerance_amount_label: Label = $Panel2/ErrorToleranceLabel/ErrorToleranceAmountLabel
var screen_manager: Node = null


func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
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
			
func _on_start_game_pressed() -> void:
	screen_manager.swap_to("Game")
	GameManager.fall_speed_accel += GameManager.fall_speed_accel * 0.035
	GameManager.max_spawn_delay  *= 0.9


func _on_shop_button_pressed() -> void:
	screen_manager.show_overlay("ShopOverlay")
