extends Node
var current_creature_data: CreatureData = null
var creatures_datas: Array[CreatureData]
var creature_weights: Dictionary[float, CreatureData]
var player: Player = null
var total_weight: float = 0.0

func load_creatures() -> void:
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
func load_objects() -> void:
	var folder_path: String = "res://Object/Objects"
	var object_folder = DirAccess.open(folder_path)
	if object_folder:
		object_folder.list_dir_begin()
		var file_name = object_folder.get_next()
		while file_name != "":
			if file_name == "." or file_name == ".." or object_folder.current_is_dir():
				file_name = object_folder.get_next()
				continue
			var full_path: String = folder_path + "/" + file_name
			
			var scene: FallingObjectData = load(full_path)
			
			if scene:
				ScreenManager.GAME.objects.append(scene)
			else:
				print("Failed to load resource: ", full_path)
			file_name = object_folder.get_next()
func _ready() -> void:
	load_objects()
	load_creatures()
	
func check_bucket() -> Vector2:
	var bucket_item_counts: Dictionary[String, int] = player.held_item_counts
	var correct_item_count: int = 0
	var incorrect_item_count: int = 0

	# Check each item the player is holding
	for creature_name in bucket_item_counts.keys():
		var count = bucket_item_counts[creature_name]
		print(creature_name, current_creature_data.name)
		if creature_name == current_creature_data.name:
			correct_item_count += count
		else:
			incorrect_item_count += count

	# Debug print (optional)
	print("Correct:", correct_item_count, " Incorrect:", incorrect_item_count)
	return Vector2(correct_item_count, incorrect_item_count)
			
func successful_haul(correct_count: int, incorrect_count: int) -> bool:
	return correct_count >= current_creature_data.correct_items_required and (incorrect_count < current_creature_data.error_tolerance)
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
