extends Node2D
@onready var delay_timer: Timer = $DelayTimer

var spawn_speed: float = 0.0
var spawn_length: float = 30
var min_spawn_delay: float = 0.3
var can_spawn: bool = false
func _ready() -> void:
	SignalBus.start_spawning.connect(_on_start_spawning)
	SignalBus.stop_spawning.connect(_on_stop_spawning)
	
func spawn_object() -> void:
	if can_spawn:
		var object: FallingObject = pick_rand_object()
		var x_position: int = pick_position()
		object.global_position = Vector2(x_position, global_position.y)
		add_child(object)
		delay_timer.wait_time = 0.8
		delay_timer.wait_time += randf_range(min_spawn_delay, GameManager.max_spawn_delay)
		delay_timer.start()
	
func pick_position() -> int:
	var min_pos: int = global_position.x - int(spawn_length / 2)
	var max_pos: int = global_position.x + int(spawn_length / 2)
	return randi_range(min_pos, max_pos)
func pick_from_list(array: Array) -> FallingObject:
	var index_range = Vector2(0, array.size() - 1)
	var rand_index = randi_range(index_range.x, index_range.y)
	var object_data: FallingObjectData = GameManager.objects[rand_index]
	var falling_object: FallingObject = preload("res://Object/falling_object.tscn").instantiate()
	falling_object.set_data(object_data)
	return falling_object
	
func pick_rand_object() -> FallingObject:
	var current_creature_object_rand: float = randf()
	
	if current_creature_object_rand <= 0.83:
		return pick_from_list(GameManager.objects)
	else:
		return pick_from_list(CreatureUiManager.current_creature_data.associated_items)

func _on_start_spawning() -> void:
	#print("Started Spawning")
	var rand = randf_range(0.6, 4)
	await get_tree().create_timer(rand + 0.6).timeout
	can_spawn = true
	spawn_object()
	
func _on_stop_spawning() -> void:
	can_spawn = false
	for child in get_children():
		if is_instance_valid(child) and child is FallingObject:
			child.queue_free()
	
func _on_delay_timer_timeout() -> void:
	spawn_object()
