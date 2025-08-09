extends Control
@onready var game_time: Label = $GameTime
var screen_manager: Node = null

func _ready() -> void:
	SignalBus.game_timer_changed.connect(_on_game_timer_changed)
	#SignalBus.overlay_activated.connect(_on_overlay_activated)

func _on_game_timer_changed(new_time: float) -> void:
	game_time.text = str(int(new_time))
