extends Control
@onready var character_texture: TextureRect = $CanvasLayer/Control/CharacterTexture
@onready var correct_num: Label = $CanvasLayer/Control/CorrectItems/CorrectNum
@onready var incorrect_num: Label = $CanvasLayer/Control/IncorrectItems/IncorrectNum
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
	
func hide_screen() -> void:
	$CanvasLayer.visible = false
	
func show_screen() -> void:
	$CanvasLayer.visible = true

func _on_screen_swapped(screen) -> void:
	if screen == self:
		character_texture.texture = CreatureUiManager.current_creature_data.texture
		var collected_items: Vector2 = CreatureUiManager.check_bucket()
		correct_num.text = str(int(collected_items.x))
		incorrect_num.text = str(int(collected_items.y))
		
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
func _on_button_pressed() -> void:
	var collected_items: Vector2 = CreatureUiManager.check_bucket()
	if CreatureUiManager.successful_haul(collected_items.x, collected_items.y):
		ScreenManager.swap_to("PreRoundMenu")
		
	else:
		ScreenManager.swap_to("GameOverMenu")
	
