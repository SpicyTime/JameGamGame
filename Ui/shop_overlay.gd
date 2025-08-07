extends Control
@onready var item_description_label: Label = $Panel/ItemDescriptionLabel
@onready var grid_container: GridContainer = $Panel/GridContainer

var screen_manager: Node = null

func refresh_buttons() -> void:
	for item in grid_container.get_children():
		if item is ShopItem:
			item.refresh(GameManager.player_currency)

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
	refresh_buttons()
	
func _on_overlay_activated(overlay_node: Control) -> void:
	if overlay_node == self:
		refresh_buttons()

func _on_overlay_deactivated(overlay_node: Control) -> void:
	pass


func _on_exit_button_pressed() -> void:
	screen_manager.hide_overlay("ShopOverlay")
