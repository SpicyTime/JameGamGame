extends Node

var PRE_ROUND_MENU = preload("res://Ui/Screens/pre_round_menu.tscn").instantiate()
var GAME_OVER_MENU = preload("res://Ui/Screens/game_over_menu.tscn").instantiate()
var MAIN_MENU = preload("res://Ui/Screens/main_menu.tscn").instantiate()
var PAUSE_MENU = preload("res://Ui/Screens/pause_menu.tscn").instantiate()
var SETTINGS_MENU = preload("res://Ui/Screens/settings_menu.tscn").instantiate()
var GAME = preload("res://Game/game.tscn").instantiate()

var screens: Dictionary = {
	"PreRoundMenu": PRE_ROUND_MENU,
	"GameOverMenu": GAME_OVER_MENU,
	"MainMenu": MAIN_MENU,
	"PauseMenu": PAUSE_MENU,
	"SettingsMenu": SETTINGS_MENU,
	"Game": GAME
}
var active_screen: Node = null

func _ready():
	get_tree().paused = true
	for screen in screens.values():
		add_child(screen)
		hide_active_screen(screen)
		
	swap_to("MainMenu")
	
func swap_to(name: String) -> void:
		
	if active_screen:
		hide_active_screen(active_screen)
		
	if screens.has(name):
		active_screen = screens[name]
		show_active_screen(active_screen)
	else:
		push_error("Screen not found: " + name)
		
	if name == "Game":
		get_tree().paused = false
	else:
		get_tree().paused = true
		
	SignalBus.screen_swapped.emit(active_screen)
	
func show_active_screen(screen) -> void:
	if screen.has_method("show_screen"):
		screen.show_screen()
		
func hide_active_screen(screen) -> void:
	if screen.has_method("hide_screen"):
		screen.hide_screen()
	
