extends Button
class_name ShopItem
@export var item_name: String = ""
@export var base_description: String = ""
@export var item_icon_texture: Texture2D = null
@export var item_type: ShopItemEffectHandler.ItemType
@export var tier_count: int = 1
@export var tier_effects: Array[float] = []
@export var tier_costs: Array[int] = []
@export var tier_textures: Array[Texture2D]
@onready var item_icon: TextureRect = $Icon
@onready var name_label: Label = $NameLabel
@onready var price_label: Label = $PriceLabel
var current_tier: int = 1
var indexed_tier: int = 0
var description: String = base_description
func get_roman(number: int) -> String:
	var roman: String = ""
	if number == 0:
		return "l"
	if number <= 3:
		for i in range(number) :
			roman += "l"
	elif number == 4:
		roman = "lV"
	elif number >= 5:
		roman = "V"
		for i in range(number - 5):
			roman += "l"
	
	return roman
	
func update_description() -> void:
	if base_description.find("%") != -1:
		var array = base_description.split("%")
		description = array[0] + str(tier_effects[indexed_tier]) + "%" + array[1]
		
func refresh(player_currency: int) -> void:
	name_label.text = item_name + get_roman(current_tier)
	
	if current_tier > tier_count:
		name_label.text = item_name + "MAX"
		disabled = true
		price_label.text = ""
		description = "MAXED"
		return
	else:
		price_label.text = str(tier_costs[indexed_tier])
		
	if player_currency < tier_costs[indexed_tier]:
		disabled = true
	update_description()
	
func _ready() -> void:
	item_icon.texture = item_icon_texture
	refresh(GameManager.player_currency)
	description = base_description
	
func _on_mouse_entered() -> void:
	SignalBus.item_hovered.emit(description)

func _on_mouse_exited() -> void:
	SignalBus.item_unhovered.emit()

func _on_pressed() -> void:
	var cost = tier_costs[indexed_tier]
	if GameManager.player_currency >= cost:
		GameManager.player_currency -= cost
		SignalBus.item_bought.emit(self)
		current_tier += 1
		indexed_tier += 1
		SignalBus.refresh_shop.emit()
		SignalBus.item_hovered.emit(description)
		
