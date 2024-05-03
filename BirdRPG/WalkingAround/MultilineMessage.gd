extends StaticBody2D

@export var messages: Array[String] = ["Hello", "I'm a frog"]
@export var is_special_scene := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select():
	if is_special_scene:
		BR.initiate_special_scene.emit()
		await BR.begin_scene
	BR.scene_message.emit(messages)
