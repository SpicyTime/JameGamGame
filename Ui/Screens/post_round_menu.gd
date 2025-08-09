extends Control
@onready var character_texture: TextureRect = $CharacterTexture
@onready var plus_label: Label = $BucketTexture/PlusLabel
@onready var minus_label: Label = $BucketTexture/MinusLabel
@onready var next_creature_button: Button = $NextCreatureButton
@onready var waterfall: TextureRect = $Waterfall
@onready var wall: TextureRect = $Wall
@onready var counter: TextureRect = $Counter
@onready var bucket: TextureRect = $BucketTexture
const ANGERSPRITE = preload("res://Characters/Angersprite.png")
const GREENSPRITE = preload("res://Characters/Greensprite.png")
var original_positions := {}
var original_modulates := {}
var original_textures := {}

var screen_manager: Node = null
var difference: int = 0
var current_incorrect_amount: float = 0
var current_correct_amount: float = 0

func animate_waterfall() -> void:
	var frame: int = 0
	var total_frames: int = 6
	while(true):
		var waterfall_texture: AtlasTexture = waterfall.texture as AtlasTexture
		var x = (frame % total_frames) * 320
		waterfall_texture.region.position.x = x
		frame = (frame + 1) % total_frames
		await get_tree().create_timer(0.5).timeout # 10 fps
func push_bucket_up(amount: float) -> void:
	var bucket_pos_tween: Tween = create_tween()
	bucket_pos_tween.tween_property(bucket, "position", Vector2(bucket.position.x, bucket.position.y - amount), 3)\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
		
func character_shake(amount_left: int, amount_right: int) -> void:
	var character_pos_x: float = character_texture.position.x
	var character_pos_y: float = character_texture.position.y
	var character_pos_tween: Tween = create_tween()
	var duration = 0.1
	character_pos_tween.tween_property(character_texture, "position", Vector2(character_pos_x - amount_left, character_pos_y),duration)\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	character_pos_tween.tween_property(character_texture, "position", Vector2(character_pos_x + amount_right, character_pos_y), duration)\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	character_pos_tween.tween_property(character_texture, "position", Vector2(character_pos_x, character_pos_y), duration)\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
		
func character_jump(amount_up: int):
	var character_pos_x: float = character_texture.position.x
	var character_pos_y: float = character_texture.position.y
	var character_pos_tween: Tween = create_tween()
	character_pos_tween.tween_property(character_texture, "position", Vector2(character_pos_x, character_pos_y - amount_up), 0.7)\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	character_pos_tween.tween_property(character_texture, "position", Vector2(character_pos_x, character_pos_y), 0.7)\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
		
func label_count_tweens() -> void:
	var duration: float = 0.75
	var plus_end: int = GameManager.correct_items
	var minus_end: int = -GameManager.incorrect_items

	var prev_plus: int = 0
	var prev_minus: int = 0

	# Tween for plus_label
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value):
			var int_val = round(value)
			if int_val > prev_plus:
				play_tick_sound()
			prev_plus = int_val
			plus_label.text = "+" + str(int_val),
		0,
		plus_end,
		duration
	)

	# Tween for minus_label
	var tween2 := create_tween()
	tween2.set_trans(Tween.TRANS_SINE)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_method(
		func(value):
			var int_val = round(value)
			if int_val < prev_minus:
				play_tick_sound()
			prev_minus = int_val
			minus_label.text = str(int_val),
		0,
		minus_end,
		duration
	)

func play_tick_sound() -> void:
	var sfx = AudioStreamPlayer.new()
	sfx.stream = preload("res://Ui/SFX/buttonclick.wav") # change to your sound path
	add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx.queue_free)
	
func increase_requirements() -> void:
	var rand_f: float = randf()
	var current_creature: CreatureData = CreatureUiManager.current_creature_data
	if rand_f > current_creature.appearance_weight:
		var increase_min_chance: float = 0.25
		if randf() <= increase_min_chance:
			if current_creature.correct_range.x >= current_creature.correct_range.y - 1:
				current_creature.correct_range.y += 1
			else:
				current_creature.correct_range.x += 1
		else:
			current_creature.correct_rangey += 1
			
		current_creature.correct_range.y += 1
		
		
func start_tweens() -> void:
	var bucket_texture_pos: Vector2 = bucket.position
	var button_position = next_creature_button.position
	var half_vieport_x: float = get_viewport_rect().size.x / 2
	var half_bucket_size_x: float = bucket.texture.get_size().x / 2
	var counter_position: Vector2 = counter.position
	var wall_position: Vector2 = wall.position
	var character_position: Vector2 = character_texture.position
	next_creature_button.position.y = 450
	bucket_texture_pos.x += 300
	character_texture.position.y = 450
	counter.position.y = 400
	wall.position.y = 640
	bucket.position = bucket_texture_pos
	var element_pos_tween: Tween = create_tween()\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	element_pos_tween.parallel().tween_property(counter, "position",counter_position, 1.25)
	element_pos_tween.parallel().tween_property(wall, "position", wall_position, 1.25)
	#await get_tree().create_timer(1).timeout
	element_pos_tween.tween_property(character_texture, "position", character_position, 1.25)
	await get_tree().create_timer(2).timeout
	var bucket_pos_tween: Tween = create_tween()\
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
	
	bucket_pos_tween.tween_property(bucket, "position", Vector2(half_vieport_x - half_bucket_size_x, 107), 1.0) 
	await bucket_pos_tween.finished

	var label_fade_tween: Tween = create_tween().set_parallel(true)

	plus_label.modulate.a = 0.0
	minus_label.modulate.a = 0.0
	plus_label.text = "+0"
	minus_label.text = "-0"

	label_fade_tween.tween_property(plus_label, "modulate:a", 1.0, 1.0)
	label_fade_tween.tween_property(minus_label, "modulate:a", 1.0, 1.0)

	await label_fade_tween.finished

	label_count_tweens()

	await get_tree().create_timer(1.5).timeout
	
	push_bucket_up(15)
	
	await get_tree().create_timer(2).timeout
	if not check_successful_haul():
		$CharacterTexture/ApprovalTexture.texture = ANGERSPRITE
		character_shake(10, 10)
		await get_tree().create_timer(0.5).timeout
		screen_manager.show_overlay("DeathTransitionOverlay")
	else:
		$CharacterTexture/ApprovalTexture.texture = GREENSPRITE
		character_jump(10)
		await get_tree().create_timer(0.5).timeout
		var button_pos_tween: Tween = create_tween()
		if not difference <= 0:
			GameManager.player_currency += difference
		button_pos_tween.tween_property(next_creature_button, "position", button_position, 1)\
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
		var label_tween = create_tween()
		label_tween.parallel().tween_property(plus_label, "modulate:a", 0, 1.0)
		label_tween.parallel().tween_property(minus_label, "modulate:a", 0, 1.0)
		
	$CharacterTexture/ApprovalTexture.visible = true
func end_tweens() -> void:
	var character_pos_tween: Tween = create_tween()
	var character_target_pos: Vector2 = Vector2(-400, character_texture.position.y)
	character_pos_tween.tween_property(character_texture, "position", character_target_pos, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	minus_label.modulate.a = 0.0
	plus_label.modulate.a = 0.0

	var bucket_pos_tween: Tween = create_tween()
	var bucket_target_pos: Vector2 = Vector2(-400, bucket.position.y)
	bucket_pos_tween.tween_property(bucket, "position", bucket_target_pos, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	var creature_button_pos_tween: Tween = create_tween()
	var creature_target_pos: Vector2 = Vector2(next_creature_button.position.y, 450)
	creature_button_pos_tween.tween_property(next_creature_button, "position", creature_target_pos, 0.5)\
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
	
func check_successful_haul() -> bool:
	return GameManager.incorrect_items <= CreatureUiManager.current_creature_data.error_tolerance and(
	   GameManager.correct_items >= CreatureUiManager.current_creature_data.correct_items_required)



func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	animate_waterfall()

	# Save original positions
	original_positions.character_texture = character_texture.position
	original_positions.plus_label = plus_label.modulate
	original_positions.minus_label = minus_label.modulate
	original_positions.next_creature_button = next_creature_button.position
	original_positions.bucket = bucket.position
	original_positions.counter = counter.position
	original_positions.wall = wall.position

	# Save default modulates
	original_modulates.plus_label = plus_label.modulate

func reset_ui() -> void:
	# Exact original positions
	character_texture.position = original_positions.character_texture
	bucket.position = original_positions.bucket
	counter.position = original_positions.counter
	wall.position = original_positions.wall
	next_creature_button.position = original_positions.next_creature_button
	original_modulates.minus_label = minus_label.modulate

	# Reset labels
	plus_label.text = "+0"
	minus_label.text = "-0"
	plus_label.modulate = Color(original_modulates.plus_label.r,
								original_modulates.plus_label.g,
								original_modulates.plus_label.b,
								0.0)
	minus_label.modulate = Color(original_modulates.minus_label.r,
								 original_modulates.minus_label.g,
								 original_modulates.minus_label.b,
								 0.0)

	# Reset Approval texture
	$CharacterTexture/ApprovalTexture.visible = false


func _on_screen_swapped(screen) -> void:
	if screen == self:
		character_texture.texture = CreatureUiManager.current_creature_data.texture
		current_correct_amount = 0
		current_incorrect_amount = 0
		difference = GameManager.correct_items - GameManager.incorrect_items
		print(difference)
		bucket.texture = GameManager.current_player_texture
		$BucketTexture/BandTexture.texture = GameManager.current_band_texture
		
		
		$CharacterTexture/ApprovalTexture.visible = false
		reset_ui()
		start_tweens()
		
func _on_button_pressed() -> void:
		end_tweens()
		await get_tree().create_timer(1.5).timeout
		screen_manager.swap_to("PreRoundMenu")
	
