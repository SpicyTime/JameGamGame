extends Control
@onready var character_texture: TextureRect = $CharacterTexture
@onready var correct_num: Label = $CorrectItems/CorrectNum
@onready var incorrect_num: Label = $IncorrectItems/IncorrectNum
var screen_manager: Node = null

func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	
func _on_screen_swapped(screen) -> void:
	if screen == self:
		character_texture.texture = CreatureUiManager.current_creature_data.texture
		incorrect_num.text = str(GameManager.incorrect_items)
		correct_num.text = str(GameManager.correct_items)
		
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
	if GameManager.incorrect_items > CreatureUiManager.current_creature_data.error_tolerance:
		screen_manager.swap_to("GameOverMenu")
	else:
		screen_manager.swap_to("PreRoundMenu")
	
