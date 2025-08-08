extends Node
var fall_speed_accel: float = 5
var max_spawn_delay: float = 4
var player_currency: int = 100
var incorrect_items: int = 0
var correct_items: int = 0
var objects: Array

func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)
	
func _on_game_over() -> void:
	player_currency = 0
	max_spawn_delay = 4
	fall_speed_accel = 5
	incorrect_items =0
	correct_items = 0
