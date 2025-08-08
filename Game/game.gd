extends Node2D
var spawn_speed: float = 0.2
@onready var game_timer: Timer = $GameTimer
var screen_manager: Node = null
func _process(_delta: float) -> void:
	SignalBus.game_timer_changed.emit(game_timer.time_left)
	
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	SignalBus.game_timer_changed.emit(game_timer.time_left)
		
func show_screen() -> void:
	visible = true
	
func hide_screen() -> void:
	visible = false
	print("Hiding Game")
	
func _on_screen_swapped(screen) -> void:
	if screen == self:
		screen_manager.show_overlay("HudOverlay")
		get_tree().paused = false
		SignalBus.start_spawning.emit()
		game_timer.start()
		game_timer.paused = true
		await get_tree().create_timer(3).timeout
		game_timer.paused = false
		
	else:
		screen_manager.hide_overlay("HudOverlay")
		SignalBus.stop_spawning.emit()

func _on_game_timer_timeout() -> void:
	screen_manager.swap_to("PostRoundMenu")
