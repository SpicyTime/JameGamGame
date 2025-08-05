extends Resource
class_name CreatureData

@export var name: String = ""
@export var appearance_weight: float = 0.0
@export var texture: Texture2D = null
@export var associated_items: Array[FallingObjectData] = []
@export var correct_range: Vector2  = Vector2.ZERO
@export var incorrect_range: Vector2 = Vector2.ZERO
var correct_items_required: int = 0
var error_tolerance: int = 0
