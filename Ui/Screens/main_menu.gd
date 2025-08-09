extends Control
var screen_manager: Node = null
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var game_name_label: Label = $GameNameLabel
@onready var waterfall: TextureRect = $Waterfall


func _ready() -> void:
	animate_waterfall()

	
func end_tweens() -> void:
	var pos_tween: Tween = create_tween().set_parallel()
	pos_tween.tween_property(game_name_label, "position", Vector2(-400, game_name_label.position.y), 0.75)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_ease(Tween.EASE_IN)
	
	AudioManager.play_whoosh()
	pos_tween.tween_property(v_box_container, "position", Vector2(-400, v_box_container.position.y), 0.75)\
	.set_trans(Tween.TRANS_CUBIC)\
	.set_ease(Tween.EASE_IN)
	AudioManager.play_whoosh()
	
func _on_play_button_pressed() -> void:
	end_tweens()
	await get_tree().create_timer(1).timeout
	screen_manager.swap_to("PreRoundMenu")

func _on_settings_button_pressed() -> void:
	screen_manager.show_overlay("SettingsOverlay")
	

func animate_waterfall() -> void:
	var frame: int = 0
	var total_frames: int = 6
	while(true):
		var waterfall_texture: AtlasTexture = waterfall.texture as AtlasTexture
		var x = (frame % total_frames) * 320
		waterfall_texture.region.position.x = x
		frame = (frame + 1) % total_frames
		await get_tree().create_timer(0.5).timeout # 10 fps
