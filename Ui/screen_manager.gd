extends Node

var PRE_ROUND_MENU = preload("res://Ui/Screens/pre_round_menu.tscn").instantiate()
var POST_ROUND_MENU = preload("res://Ui/Screens/post_round_menu.tscn").instantiate()
var GAME_OVER_MENU = preload("res://Ui/Screens/game_over_menu.tscn").instantiate()
var MAIN_MENU = preload("res://Ui/Screens/main_menu.tscn").instantiate()
var GAME = preload("res://Game/game.tscn").instantiate()
var SHOP_OVERLAY = preload("res://Ui/shop_overlay.tscn").instantiate()
var HUD_OVERLAY = preload("res://Ui/hud.tscn").instantiate()
var PAUSE_OVERLAY = preload("res://Ui/Screens/pause_menu.tscn").instantiate()
var DEATH_TRANSITION_OVERLAY = preload("res://Ui/death_transition_overlay.tscn").instantiate()
var SETTINGS_OVERLAY = preload("res://Ui/Screens/settings_overlay.tscn").instantiate()

var screens: Dictionary = {
	"PreRoundMenu": PRE_ROUND_MENU,
	"GameOverMenu": GAME_OVER_MENU,
	"PostRoundMenu": POST_ROUND_MENU,
	"MainMenu": MAIN_MENU,
	"Game": GAME
}

var overlays: Dictionary = {
	"ShopOverlay": SHOP_OVERLAY,
	"HudOverlay": HUD_OVERLAY,
	"PauseOverlay": PAUSE_OVERLAY,
	"DeathTransitionOverlay": DEATH_TRANSITION_OVERLAY,
	"SettingsOverlay": SETTINGS_OVERLAY
}

var active_screen: Node = null
var active_overlay: Control = null

func _ready():
	get_tree().paused = true
	#Adds screens
	for screen in screens.values():
		if screen is Control:
			$CanvasLayer.add_child(screen)
			screen.screen_manager = self
		else:
			add_child(screen)
			screen.screen_manager = self
		screen.visible = false
	#Adds overlays
	for overlay in overlays.values():
		$CanvasLayer.add_child(overlay)
		#overlay.visible = false
		overlay.screen_manager = self
		overlay.visible = false
	#show_overlay("ShopOverlay")
	swap_to("MainMenu")
	
func swap_to(screen_name: String) -> void:
	if active_screen:
		active_screen.visible = false
		
	if screens.has(screen_name):
		active_screen = screens[screen_name]
		active_screen.visible = true
	else:
		push_error("Screen not found: " + screen_name)
		
	if screen_name == "Game":
		if get_tree():
			get_tree().paused = false
		#
	else:
		if get_tree():
			get_tree().paused = true
		
	SignalBus.screen_swapped.emit(active_screen)

func show_overlay(overlay_name: String) -> void:
	if overlays.has(overlay_name):
		get_tree().paused = true
		overlays[overlay_name].visible = true
		SignalBus.overlay_activated.emit(overlays[overlay_name])
		
				
func hide_overlay(overlay_name) -> void:
	if overlays.has(overlay_name):
		overlays[overlay_name].visible = false
		SignalBus.overlay_deactivated.emit(overlays[overlay_name])
		
