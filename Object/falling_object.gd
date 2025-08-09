extends CharacterBody2D
class_name FallingObject
var data: FallingObjectData = null
var GRAVITY: float = 980

func increase_fall_deceleration(value: float):
	GameManager.fall_speed_decel += value

func get_associated_creature_name() -> String:
	return data.associated_creature
	
func set_data(new_data: FallingObjectData):
	data = new_data
	setup(data)
	
func setup(curr_data: FallingObjectData):
	$Sprite2D.texture = curr_data.texture

func _physics_process(delta: float) -> void:
	if data:
		velocity.y = GRAVITY * delta * GameManager.fall_speed_accel * GameManager.fall_speed_decel
	if global_position.y > get_viewport_rect().size.y / 2:
		queue_free()
	move_and_slide()
