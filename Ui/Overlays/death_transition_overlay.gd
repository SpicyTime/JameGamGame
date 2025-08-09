extends ColorRect
var screen_manager: Node = null
func _ready() -> void:
	SignalBus.overlay_activated.connect(_on_overlay_activated)
	
func _on_overlay_activated(overlay_node: Control):
	if overlay_node == self:
		$AnimationPlayer.play("progress")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "progress":
		screen_manager.swap_to("GameOverMenu")
		screen_manager.hide_overlay("DeathTransitionOverlay")
		$AnimationPlayer.play("RESET")
