extends Node2D
var objects: Array[FallingObjectData] = []
var spawn_speed: float = 0.2
@onready var game_timer: Timer = $GameTimer

func _process(delta: float) -> void:
	SignalBus.game_timer_changed.emit(game_timer.time_left)
	
func _ready() -> void:
	SignalBus.screen_swapped.connect(_on_screen_swapped)
	var folder_path: String = "res://Object/Objects"
	var object_folder = DirAccess.open(folder_path)
	if object_folder:
		object_folder.list_dir_begin()
		var file_name = object_folder.get_next()
		while file_name != "":
			if file_name == "." or file_name == ".." or object_folder.current_is_dir():
				file_name = object_folder.get_next()
				continue
			var full_path: String = folder_path + "/" + file_name
			
			var scene: FallingObjectData = load(full_path)
			
			if scene:
				objects.append(scene)
			else:
				print("Failed to load resource: ", full_path)
			file_name = object_folder.get_next()

func show_screen() -> void:
	visible = true
	
func hide_screen() -> void:
	visible = false
	
func _on_screen_swapped(screen) -> void:
	if screen == self:
		SignalBus.start_spawning.emit()
		
	else:
		SignalBus.stop_spawning.emit()

func _on_game_timer_timeout() -> void:
	ScreenManager.swap_to("PostRoundMenu")
