extends Node
var current_creature_data: CreatureData = null
var creatures_datas: Array[CreatureData] = []
var creature_weights: Dictionary[float, CreatureData] = {}
const AMULET = preload("res://Object/Objects/amulet.tres")
const ANVIL = preload("res://Object/Objects/anvil.tres")
const CAULDRON = preload("res://Object/Objects/cauldron.tres")
const CLOVER = preload("res://Object/Objects/clover.tres")
const CONCH = preload("res://Object/Objects/conch.tres")
const CORAL = preload("res://Object/Objects/coral.tres")
const CRYSTAL_BALL = preload("res://Object/Objects/crystal_ball.tres")
const GEMS = preload("res://Object/Objects/gems.tres")
const HEAD_LAMP = preload("res://Object/Objects/head_lamp.tres")
const HORSE_SHOE = preload("res://Object/Objects/horse_shoe.tres")
const LEPRECHAUN_HAT = preload("res://Object/Objects/leprechaun_hat.tres")
const PEARL_NECKLACE = preload("res://Object/Objects/pearl_necklace.tres")
const PICKAXE = preload("res://Object/Objects/pickaxe.tres")
const POT_OF_GOLD = preload("res://Object/Objects/pot_of_gold.tres")
const RAINBOW = preload("res://Object/Objects/rainbow.tres")
const SMITHING_HAMMER = preload("res://Object/Objects/smithing_hammer.tres")
const STARFISH = preload("res://Object/Objects/starfish.tres")
const TRIDENT = preload("res://Object/Objects/trident.tres")
const WAND = preload("res://Object/Objects/wand.tres")
const WIZARD_HAT = preload("res://Object/Objects/wizard_hat.tres")
const DWARF = preload("res://Characters/Creature/Creatures/dwarf.tres")
const LEPRECHAUN = preload("res://Characters/Creature/Creatures/leprechaun.tres")
const MERMAID = preload("res://Characters/Creature/Creatures/mermaid.tres")
const WIZARD = preload("res://Characters/Creature/Creatures/wizard.tres")

var OBJECTS := [
	AMULET,
	ANVIL,
	CAULDRON,
	CLOVER,
	CONCH,
	CORAL,
	CRYSTAL_BALL,
	GEMS,
	HEAD_LAMP,
	HORSE_SHOE,
	LEPRECHAUN_HAT,
	PEARL_NECKLACE,
	PICKAXE,
	POT_OF_GOLD,
	RAINBOW,
	SMITHING_HAMMER,
	STARFISH,
	TRIDENT,
	WAND,
	WIZARD_HAT
]

var CREATURES := [
	DWARF,
	LEPRECHAUN,
	MERMAID,
	WIZARD
]
var total_weight: float = 0.0

func load_creatures():
	creatures_datas.clear()
	for creature in CREATURES:
		creatures_datas.append(creature)
	calc_total_weight()

func load_objects():
	GameManager.objects.clear()
	for obj in OBJECTS:
		GameManager.objects.append(obj)

func _ready() -> void:
	load_objects()
	load_creatures()
	
func calc_total_weight() -> void:
	total_weight = 0.0
	for creatures_data in creatures_datas:
		total_weight += creatures_data.appearance_weight
		creature_weights.set(creatures_data.appearance_weight, creatures_data)
		
func pick_creature() -> CreatureData:
	var rand_float: float = randf_range(0, total_weight)

	for weight in creature_weights:
		rand_float -= weight
		if rand_float <= 0:
			var picked_creature: CreatureData = creature_weights[weight]
			picked_creature.correct_items_required = pick_correct_required(picked_creature)
			picked_creature.error_tolerance = pick_incorrect_allowed(picked_creature)
			current_creature_data = picked_creature
			return picked_creature
			
	return null
	
func pick_incorrect_allowed(creature: CreatureData) -> int : 
	return randi_range(creature.incorrect_range.x, creature.incorrect_range.y)
	
func pick_correct_required(creature: CreatureData) -> int:
	return randi_range(creature.correct_range.x, creature.correct_range.y)
