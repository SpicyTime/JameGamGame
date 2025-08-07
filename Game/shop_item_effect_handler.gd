extends Node
enum ItemType {
	BUCKET_SIZE,
	BUCKET_SPEED,
	BUCKET_FILTER,
	ITEM_FALL_SPEED,
	CREATURE_ERROR_TOLERANCE,
	CREATURE_REQUIRED_AMOUNT
}

func apply_item_effect(item: ShopItem, node: Node):
	var item_type: ItemType = item.item_type
	match item_type:
		ItemType.BUCKET_SIZE:
			if node.has_method("increase_bucket_size"):
				
				node.increase_bucket_size(item.tier_effects[item.indexed_tier])
				
		ItemType.BUCKET_SPEED:
			if node.has_method("increase_bucket_speed"):
				print(item.current_tier - 1)
				node.increase_bucket_speed(item.tier_effects[item.indexed_tier])

		ItemType.BUCKET_FILTER:
			# Example: Enable filter to remove incorrect items
			if node.has_method("increase_filter_chance"):
				node.increase_filter_chance(item.tier_effects[item.indexed_tier])

		ItemType.ITEM_FALL_SPEED:
			if node.has_method("slow_item_fall_speed"):
				node.slow_item_fall_speed(item.tier_effects[item.indexed_tier])

		ItemType.CREATURE_ERROR_TOLERANCE:
			if node.has_method("increase_error_tolerance"):
				node.increase_error_tolerance(item.tier_effects[item.indexed_tier])

		ItemType.CREATURE_REQUIRED_AMOUNT:
			if node.has_method("decrease_required_amount"):
				node.decrease_required_amount(item.tier_effects[item.indexed_tier])

		_:
			push_warning("Unknown item type: %s" % str(item_type))

func _ready() -> void:
	SignalBus.item_bought.connect(_on_item_bought)
	
func _on_item_bought(item: ShopItem) -> void:
	for node in get_tree().get_nodes_in_group("ItemEffected"):
		
		apply_item_effect(item, node)
		
