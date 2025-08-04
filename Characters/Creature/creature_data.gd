extends Resource
class_name CreatureData

@export var name: String = ""
@export var appearance_weight: float = 0.0
@export var texture: Texture2D = null
@export var associated_items: Array[FallingObjectData] = []
@export var correct_items_required: int = 0
@export var incorrect_items_allowed: int = 0
