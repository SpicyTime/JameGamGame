extends CharacterBody2D
class_name FallingObject
var data: FallingObjectData = null

func get_associated_creature_name() -> String:
	return data.associated_creature.name
func set_data(new_data: FallingObjectData):
	data = new_data
	setup(data)
	
func setup(curr_data: FallingObjectData):
	$Sprite2D.texture = curr_data.texture

func _physics_process(delta: float) -> void:
	if data:
		velocity.y = data.fall_speed * delta * 5
	if global_position.y > get_viewport_rect().size.y / 2:
		print("Deleted")
		queue_free()
	move_and_slide()
