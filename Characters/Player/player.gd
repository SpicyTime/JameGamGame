extends CharacterBody2D
class_name Player
var input_vector: Vector2 = Vector2.ZERO
var friction: float = 1000
var accel: float = 900.0
var max_speed: float = 125.0
var filter_chance: float = 0.0
@onready var pickup_area_collider: CollisionShape2D = $PickupArea/CollisionShape2D

func increase_bucket_size(size_increase: int) -> void:
	var shape: RectangleShape2D = pickup_area_collider.shape
	shape.size.x += size_increase
	
func increase_bucket_speed(speed_multiplier: int) -> void:
	max_speed *= speed_multiplier / 100 + 1
	accel += 100
	
func increase_filter_chance(new_chance: float) -> void:
	filter_chance = new_chance / 100
func set_band_texture(texture: Texture2D):
	$Band.texture = texture
func _handle_input() -> void:
	input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input_vector.x = -1
	elif Input.is_action_pressed("move_right"):
		input_vector.x = 1

	if Input.is_action_just_pressed("pause"):
		get_parent().screen_manager.show_overlay("PauseOverlay")
		
func bounce_object_out(object: FallingObject) -> void:
	var rand_x: float = randf_range(1, -1) 
	object.velocity.x = rand_x * 200
func _ready() -> void:
	SignalBus.refresh_player_textures.connect(_on_player_refresh_textures)
func _physics_process(delta: float) -> void:
	_handle_input()
	
	if input_vector.x != 0:
		velocity.x = move_toward(velocity.x, max_speed * input_vector.x, delta * accel)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * friction)
		
	move_and_slide()
	
func _on_pickup_area_body_entered(body: Node2D) -> void:
	
	if body.has_method("get_associated_creature_name"):
		var associated_creature_name: String = body.get_associated_creature_name()
		if associated_creature_name != CreatureUiManager.current_creature_data.name:
			var rand_f = randf()
			if rand_f < filter_chance:
				bounce_object_out(body)
				return
			GameManager.incorrect_items += 1
		else:
			GameManager.correct_items += 1
		body.queue_free()
		
func _on_player_refresh_textures(bucket_texture: Texture2D, band_texture: Texture2D):
	$Bucket.texture = bucket_texture
	$Band.texture = band_texture
