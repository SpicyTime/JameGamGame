extends Control
@onready var character_texture: TextureRect = $CharacterTexture
@onready var grid_container: GridContainer = $AcceptableItemLabel/GridContainer
@onready var required_amount_label: Label = $RequiredSheet/RequiredLabel/RequiredAmountLabel
@onready var error_tolerance_amount_label: Label = $ErrorToleranceSheet/ErrorToleranceLabel/ErrorToleranceAmountLabel

@onready var required_sheet: Panel = $RequiredSheet
@onready var error_tolerance_sheet: Panel = $ErrorToleranceSheet
@onready var start_game_button: Button = $StartGameButton
@onready var shop_button: Button = $ShopButton

@onready var waterfall: TextureRect = $Waterfall
@onready var counter: TextureRect = $Counter
@onready var wall: TextureRect = $Wall


var original_positions := {}
var original_modulates := {}
var screen_manager: Node = null
func reset_ui() -> void:
	# Set positions exactly to original saved values
	character_texture.position = original_positions.character_texture
	grid_container.position = original_positions.grid_container
	error_tolerance_sheet.position = original_positions.error_tolerance_sheet
	required_sheet.position = original_positions.required_sheet
	start_game_button.position = original_positions.start_game_button
	shop_button.position = original_positions.shop_button
	counter.position = original_positions.counter            # added
	wall.position = original_positions.wall       
	# Reset modulate alpha to original (probably 1)
	grid_container.modulate = original_modulates.grid_container

	# Make grid container visible in case it was hidden
	grid_container.visible = true



func animate_waterfall() -> void:
	var frame: int = 0
	var total_frames: int = 6
	while(true):
		var waterfall_texture: AtlasTexture = waterfall.texture as AtlasTexture
		var x = (frame % total_frames) * 320
		waterfall_texture.region.position.x = x
		frame = (frame + 1) % total_frames
		await get_tree().create_timer(0.5).timeout 
		
func start_tweens() -> void:
	# Store original positions
	var character_start_pos: Vector2 = character_texture.position
	var grid_start_pos: Vector2 = grid_container.position
	var error_sheet_start_pos: Vector2 = error_tolerance_sheet.position
	var required_sheet_start_pos: Vector2 = required_sheet.position
	var start_game_start_pos: Vector2 = start_game_button.position
	var shop_button_start_pos: Vector2 = shop_button.position

	# Setup starting positions for animation
	character_texture.position.x = 400
	grid_container.modulate.a = 0.0
	grid_container.position.y = grid_start_pos.y - 20
	error_tolerance_sheet.position.x = error_sheet_start_pos.x + 150
	required_sheet.position.x = required_sheet_start_pos.x - 150
	start_game_button.position.y = start_game_start_pos.y + 300
	shop_button.position.y = shop_button_start_pos.y + 300
	
	var delay_timer: SceneTreeTimer = get_tree().create_timer(0.3)
	await delay_timer.timeout

	# Tween character into place
	var character_tween: Tween = create_tween()
	character_tween.tween_property(character_texture, "position", character_start_pos, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
	AudioManager.play_whoosh()
	await character_tween.finished
	var expo_out_tween = create_tween() \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	# Tween grid_container modulate and position in parallel
	expo_out_tween.parallel().tween_property(grid_container, "modulate:a", 1.0, 1.0)
	expo_out_tween.parallel().tween_property(grid_container, "position", grid_start_pos, 1.0) 
	
	# Tween sheets
	expo_out_tween.parallel().tween_property(error_tolerance_sheet, "position", error_sheet_start_pos, 1.0) 
	expo_out_tween.parallel().tween_property(required_sheet, "position", required_sheet_start_pos, 1.0) 
	AudioManager.play_whoosh()
	# Tween buttons into place

	expo_out_tween.parallel().tween_property(start_game_button, "position", start_game_start_pos, 1) 
	expo_out_tween.parallel().tween_property(shop_button, "position", shop_button_start_pos, 1) 

func end_tweens() -> void:
	$AcceptableItemLabel/GridContainer.visible = false
	var tween_pos: Tween = create_tween()\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_IN)
	tween_pos.parallel().tween_property(character_texture, "position", Vector2(character_texture.position.x, 450), 0.5)
	tween_pos.parallel().tween_property(shop_button, "position", Vector2(-400, shop_button.position.y), 0.5)
	tween_pos.parallel().tween_property(start_game_button, "position", Vector2(400, start_game_button.position.y), 0.5)
	tween_pos.parallel().tween_property(required_sheet, "position", Vector2(-400, required_sheet.position.y), 0.5)
	tween_pos.parallel().tween_property(error_tolerance_sheet, "position", Vector2(400, error_tolerance_sheet.position.y), 0.5)
	tween_pos.parallel().tween_property(counter, "position", Vector2(counter.position.x, 400), 1)
	tween_pos.parallel().tween_property(wall, "position", Vector2(wall.position.x, 640), 1)
	AudioManager.play_whoosh()


func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	animate_waterfall()

	# Save initial positions and modulates
	original_positions.character_texture = character_texture.position
	original_positions.grid_container = grid_container.position
	original_positions.error_tolerance_sheet = error_tolerance_sheet.position
	original_positions.required_sheet = required_sheet.position
	original_positions.start_game_button = start_game_button.position
	original_positions.shop_button = shop_button.position
	original_positions.counter = counter.position
	original_positions.wall = wall.position

	original_modulates.grid_container = grid_container.modulate
	
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
		reset_ui()
		start_tweens()
		
func _on_start_game_pressed() -> void:
	end_tweens()
	await get_tree().create_timer(2).timeout
	screen_manager.swap_to("Game")
	GameManager.fall_speed_accel += GameManager.fall_speed_accel * 0.035
	GameManager.max_spawn_delay  *= 0.9
func _on_shop_button_pressed() -> void:
	screen_manager.show_overlay("ShopOverlay")
