extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var classes:Array = load_Json(Player.path_json())
	for c in classes:
		var p := Player.new()
		p.apply_json(c)
		
	
	
func load_Json(path:String)->Array:
	var file = FileAccess.open(path, FileAccess.READ)
	return str_to_var(file.get_as_text())

