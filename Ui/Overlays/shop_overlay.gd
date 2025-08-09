extends Control
@onready var item_description_label: Label = $Panel/ItemDescriptionLabel
@onready var grid_container: GridContainer = $Panel/GridContainer
@onready var currency_amount_label: Label = $Panel/CurrencyTexture/CurrencyAmountLabel
@onready var bucket_size: ShopItem = $Panel/GridContainer/BucketSize
@onready var bucket_filter: ShopItem = $Panel/GridContainer/BucketFilter
var screen_manager: Node = null

func start_tweens() -> void:
	var shop_pos_tween = create_tween()
	position.x = 500
	shop_pos_tween.tween_property(self, "position", Vector2(0, 0), 0.5)\
.set_trans(Tween.TRANS_QUAD) \
.set_ease(Tween.EASE_OUT)
func end_tweens() -> void:
	var shop_pos_tween = create_tween()
	shop_pos_tween.tween_property(self, "position", Vector2(-500, 0), 0.5)\
.set_trans(Tween.TRANS_QUAD)\
.set_ease(Tween.EASE_IN)

func refresh_buttons() -> void:
	for item in grid_container.get_children():
		if item is ShopItem:
			item.refresh(GameManager.player_currency)
			
func refresh_player_texture() -> void:
	var bucket_texture: Texture2D = bucket_size.tier_textures[bucket_size.indexed_tier - 1]
	var band_texture: Texture2D = null
	
	if bucket_filter.indexed_tier != 0:
		var band_indexed_tier = bucket_filter.indexed_tier * bucket_size.current_tier - 1
		print(band_indexed_tier)
		band_texture = bucket_filter.tier_textures[band_indexed_tier]
		
	SignalBus.refresh_player_textures.emit(bucket_texture, band_texture)
	
func _ready() -> void:
	SignalBus.item_hovered.connect(_on_item_hovered)
	SignalBus.item_unhovered.connect(_on_item_unhovered)
	SignalBus.overlay_activated.connect(_on_overlay_activated)
	SignalBus.overlay_deactivated.connect(_on_overlay_deactivated)
	SignalBus.refresh_shop.connect(_on_shop_refresh)
	
func _on_item_hovered(item_description: String):
	item_description_label.text = item_description
	
func _on_item_unhovered() -> void :
	item_description_label.text = ""
	
func _on_shop_refresh() -> void:
	refresh_player_texture()
	refresh_buttons()
	
	currency_amount_label.text = str(GameManager.player_currency)
	
	
func _on_overlay_activated(overlay_node: Control) -> void:
	if overlay_node == self:
		start_tweens()
		refresh_buttons()
		currency_amount_label.text = str(GameManager.player_currency)

func _on_overlay_deactivated(overlay_node: Control) -> void:
	if overlay_node == self:
		pass


func _on_exit_button_pressed() -> void:
	end_tweens()
	await get_tree().create_timer(0.5).timeout
	screen_manager.hide_overlay("ShopOverlay")
