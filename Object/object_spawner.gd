extends Node2D
var spawn_speed: float = 0.0
@export var game: Node2D = null
var spawn_length: float = 0.0
var max_spawn_delay: float = 1.2
var min_spawn_delay: float = 0.8
func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	spawn_object()
func spawn_object() -> void:
	var object: FallingObject = pick_rand_object()
	var x_position: int = pick_position()
	object.global_position = Vector2(x_position, global_position.y)
	get_tree().root.add_child(object)
	await get_tree().create_timer(1).timeout
	$DelayTimer.wait_time = randf_range(min_spawn_delay, max_spawn_delay)
	$DelayTimer.start()
	
func pick_position() -> int:
	var min: int = global_position.x - int(spawn_length / 2)
	var max: int = global_position.x + int(spawn_length / 2)
	return randi_range(min, max)
	
func pick_rand_object() -> FallingObject:
	#print(game.objects.size())
	var index_range = Vector2(0, game.objects.size() - 1)
	var rand_index = randi_range(index_range.x, index_range.y)
	var object_data: FallingObjectData = game.objects[rand_index]
	var falling_object: FallingObject = preload("res://Object/falling_object.tscn").instantiate()
	falling_object.set_data(object_data)
	return falling_object


func _on_delay_timer_timeout() -> void:
	spawn_object()
