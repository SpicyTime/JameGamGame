extends CharacterBody2D
class_name Player
var held_item_counts: Dictionary [String, int] = {}
var input_vector: Vector2 = Vector2.ZERO
var friction: float = 1000
var accel: float = 1000.0
var max_speed: float = 300.0

func _handle_input() -> void:
	input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input_vector.x = -1
	elif Input.is_action_pressed("move_right"):
		input_vector.x = 1
		
func _ready() -> void:
	CreatureUiManager.player = self
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
		if held_item_counts.has(associated_creature_name):
			held_item_counts[associated_creature_name] += 1
		else:
			held_item_counts[associated_creature_name] = 1
		body.queue_free()
