extends Node

@onready var button_click: AudioStreamPlayer2D = $ButtonClick
@onready var button_hover: AudioStreamPlayer2D = $ButtonHover


func _ready() -> void:
	install_button_sounds(get_parent())
	
func install_button_sounds(node: Node) -> void:
	for child in node.get_children(true):
		if child.get_child_count() > 0:
			install_button_sounds(child)
		if child is Button:
			
			child.connect("mouse_entered", _on_hovered)
			child.connect("pressed", _on_pressed)
			
func _on_hovered() -> void:
	button_hover.play(0.0)

func _on_pressed() -> void:
	button_click.play(0.0)
