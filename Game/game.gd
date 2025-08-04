extends Node2D
var objects: Array[FallingObjectData] = []
var spawn_speed: float = 0.2
func _ready() -> void:
	var folder_path: String = "res://Object/Objects"
	var object_folder = DirAccess.open(folder_path)
	print(object_folder)
	if object_folder:
		print("Folder")
		object_folder.list_dir_begin()
		var file_name = object_folder.get_next()
		while file_name != "":
			print(file_name)
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
				
