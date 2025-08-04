extends Sprite2D
@onready var  wizard_resource: CreatureData = preload("res://Characters/Creature/wizard.tres")
	
func setup(data: CreatureData):
	texture = data.texture
	#Load the little menu with 
