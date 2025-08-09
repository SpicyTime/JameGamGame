extends Node
var fall_speed_accel: float = 5
var fall_speed_decel: float = 1
var max_spawn_delay: float = 3
var player_currency: int = 0
var incorrect_items: int = 0
var correct_items: int = 0
var objects: Array = []
var current_player_texture: Texture2D = preload("res://Characters/Player/Bucket.png")
var current_band_texture: Texture2D = null

func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)
	
func _on_game_over() -> void:
	player_currency = 0
	max_spawn_delay = 4
	fall_speed_accel = 5
	fall_speed_decel = 1
	incorrect_items = 0
	correct_items = 0
