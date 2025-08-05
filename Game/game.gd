extends Node2D
var objects: Array[FallingObjectData] = []
var spawn_speed: float = 0.2
@onready var game_timer: Timer = $GameTimer

func _process(delta: float) -> void:
	SignalBus.game_timer_changed.emit(game_timer.time_left)
	
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
		
		
func show_screen() -> void:
	visible = true
	
func hide_screen() -> void:
	visible = false
	print("Hiding Game")
	
func _on_screen_swapped(screen) -> void:
	if screen == self:
		SignalBus.start_spawning.emit()
		game_timer.start()
	else:
		SignalBus.stop_spawning.emit()

func _on_game_timer_timeout() -> void:
	ScreenManager.swap_to("PostRoundMenu")
