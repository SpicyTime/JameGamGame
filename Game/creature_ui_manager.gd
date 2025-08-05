extends Node
var current_creature_data: CreatureData = null
var creatures_datas: Array[CreatureData]
var creature_weights: Dictionary[float, CreatureData]
var player: Player = null
var total_weight: float = 0.0

func _ready() -> void:
	var folder_path: String = "res://Characters/Creature/Creatures"
	var creature_folder: DirAccess = DirAccess.open(folder_path)
	if creature_folder:
		creature_folder.list_dir_begin()
		var filename: String = creature_folder.get_next()
		while filename != "":
			var full_path: String = folder_path + "/" + filename
			var scene: CreatureData = load(full_path)
			if scene:
				creatures_datas.append(scene)
			else:
				print("Failed to load creature")
			filename = creature_folder.get_next()
	calc_total_weight()
	
func check_bucket() -> void: 
	var bucket_item_counts: Dictionary[String, int] = player.held_item_counts
	var creature_items: Array[FallingObjectData] = current_creature_data.associated_items
	var creature_item_names: Array[String]
	for item in creature_items:
		creature_item_names.append(item.name)
	var correct_item_count: int = 0
	var incorrect_item_count: int = 0
	
	for item_name in bucket_item_counts:
		var count = bucket_item_counts[item_name]
		if item_name not in creature_item_names:
			incorrect_item_count += count
		else:
			correct_item_count += count
			
func successful_haul(correct_count: int, incorrect_count: int) -> bool:
	return correct_count >= current_creature_data.correct_items_required and (incorrect_count < current_creature_data.incorrect_items_allowed)
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
			var picked_creature = creature_weights[weight]
			current_creature_data = picked_creature
			return picked_creature
	return null
	
