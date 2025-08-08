extends Control
@onready var character_texture: TextureRect = $CharacterTexture
@onready var grid_container: GridContainer = $AcceptableItemLabel/GridContainer
@onready var required_amount_label: Label = $RequiredSheet/RequiredLabel/RequiredAmountLabel
@onready var error_tolerance_amount_label: Label = $ErrorToleranceSheet/ErrorToleranceLabel/ErrorToleranceAmountLabel
@onready var currency_amount_label: Label = $CurrencyTexture/CurrencyAmountLabel
@onready var required_sheet: Panel = $RequiredSheet
@onready var error_tolerance_sheet: Panel = $ErrorToleranceSheet
@onready var start_game: Button = $StartGame
@onready var shop_button: Button = $ShopButton

var screen_manager: Node = null

func start_tweens() -> void:
	# Store original positions
	var character_start_pos: Vector2 = character_texture.position
	var grid_start_pos: Vector2 = grid_container.position
	var error_sheet_start_pos: Vector2 = error_tolerance_sheet.position
	var required_sheet_start_pos: Vector2 = required_sheet.position
	var start_game_start_pos: Vector2 = start_game.position
	var shop_button_start_pos: Vector2 = shop_button.position

	# Setup starting positions for animation
	character_texture.position.x = 400
	grid_container.modulate.a = 0.0
	grid_container.position.y = grid_start_pos.y - 20
	error_tolerance_sheet.position.x = error_sheet_start_pos.x + 150
	required_sheet.position.x = required_sheet_start_pos.x - 150
	start_game.position.y = start_game_start_pos.y + 300
	shop_button.position.y = shop_button_start_pos.y + 300

	var delay_timer: SceneTreeTimer = get_tree().create_timer(0.3)
	await delay_timer.timeout

	# Tween character into place
	var character_tween: Tween = create_tween()
	character_tween.tween_property(character_texture, "position", character_start_pos, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
	await character_tween.finished

	# Tween grid_container modulate and position in parallel
	var items_tween: Tween = create_tween().set_parallel(true)
	items_tween.tween_property(grid_container, "modulate:a", 1.0, 1.0)
	items_tween.tween_property(grid_container, "position", grid_start_pos, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	# Tween error sheet
	var error_sheet_tween: Tween = create_tween()
	error_sheet_tween.tween_property(error_tolerance_sheet, "position", error_sheet_start_pos, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	# Tween required sheet
	var required_sheet_tween: Tween = create_tween()
	required_sheet_tween.tween_property(required_sheet, "position", required_sheet_start_pos, 1.0) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)

	# Tween buttons into place
	var buttons_tween: Tween = create_tween().set_parallel(true)
	buttons_tween.tween_property(start_game, "position", start_game_start_pos, 1) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	buttons_tween.tween_property(shop_button, "position", shop_button_start_pos, 1) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
	
func _on_screen_swapped(screen) -> void:
	if screen == self:
		var current_creature = CreatureUiManager.pick_creature()
		currency_amount_label.text = str(GameManager.player_currency)
		character_texture.texture = current_creature.texture
		start_tweens()
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
