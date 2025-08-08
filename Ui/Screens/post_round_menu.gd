extends Control
@onready var character_texture: TextureRect = $CharacterTexture
@onready var currency_amount_label: Label = $CurrencyTexture/CurrencyAmountLabel
@onready var plus_label: Label = $BucketTexture/PlusLabel
@onready var minus_label: Label = $BucketTexture/MinusLabel
@onready var next_creature_button: Button = $NextCreatureButton
@onready var bucket: TextureRect = $BucketTexture
const ANGERSPRITE = preload("res://Characters/Angersprite.png")
const GREENSPRITE = preload("res://Characters/Greensprite.png")

var screen_manager: Node = null
var difference: int = 0
var current_incorrect_amount: float = 0
var current_correct_amount: float = 0

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
	character_pos_tween.tween_property(character_texture, "position", Vector2(character_pos_x + amount_left, character_pos_y), duration)\
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
	var plus_end: int = GameManager.correct_items + 10
	var minus_end: int= -GameManager.incorrect_items  - 10 # Ensure it's negative

	# Tween for plus_label (from 0 to +correct_items)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(value):
			plus_label.text = "+" + str(round(value)),
		0,
		plus_end,
		duration
	)

	# Tween for minus_label (from 0 to -incorrect_items)
	var tween2 := create_tween()
	tween2.set_trans(Tween.TRANS_SINE)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_method(
		func(value):
			minus_label.text = str(round(value)),
		0,
		minus_end,
		duration
	)
	
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
	var bucket_pos_tween: Tween = create_tween()
	var bucket_texture_pos: Vector2 = bucket.position
	var button_position = next_creature_button.position
	next_creature_button.position.y = 450
	bucket_texture_pos.x += 300
	bucket.position = bucket_texture_pos
	
	bucket_pos_tween.tween_property(bucket, "position", Vector2(140, 107), 1.0) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
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
	
	push_bucket_up(30)
	
	await get_tree().create_timer(2).timeout
	if check_successful_haul():
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
		label_fade_tween.tween_property(plus_label, "modulate:a", 0, 1.0)
	label_fade_tween.tween_property(minus_label, "modulate:a", 0, 1.0)
		
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
	return  difference > -CreatureUiManager.current_creature_data.error_tolerance

func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)

func _on_screen_swapped(screen) -> void:
	if screen == self:
		character_texture.texture = CreatureUiManager.current_creature_data.texture
		current_correct_amount = 0
		current_incorrect_amount = 0
		difference = GameManager.correct_items - GameManager.incorrect_items
		currency_amount_label.text = str(GameManager.player_currency)
		start_tweens()
		$CharacterTexture/ApprovalTexture.visible = false
		
func _on_button_pressed() -> void:
		end_tweens()
		await get_tree().create_timer(1.5).timeout
		screen_manager.swap_to("PreRoundMenu")
	
